http = require "http"
express = require "express"
socketio = require "socket.io"
controller = require "./controller"
arDrone = require "ar-drone"
connectAssets = require('connect-assets')
async = require 'async'

app = do express
httpServer = http.createServer app
httpServer.listen 3000
io = socketio.listen httpServer
io.set "log level", 2
client = arDrone.createClient()

currentImg = null

controller.init client
app.configure ->
  app.set "views", __dirname + "/client"
  app.set "view engine", "jade"
  app.use connectAssets
    src: "client/assets"
  app.use "/assets", express.static(__dirname + "/client/assets")

app.get "/", (req, res) ->
  res.render "index"

responses = []
app.get "/stream", (req, res) ->
  res.writeHead 200,
    "Content-Type": "mp4"
    # "Transfer-Encoding": "H."
  responses.push res


imageMiddleware = async.compose controller.imageMiddlewares.reverse()...

io.sockets.on "connection", (socket) ->
  socket.on "cmd", (data) ->
    action = controller[data.cmd]
    if action
      console.log data.cmd
      do action
    else
      console.log "unknown function: " + data.cmd

  client.on "navdata", (data) ->
    socket.emit "navdata", data


  imageSendingPaused = false
  client.getVideoStream().on 'data', (frame)->
    for res in responses
      res.write frame

  client.getPngStream().on 'data', (frame)->
    currentImg = frame
    return if imageSendingPaused
    imageSendingPaused = true
    socket.emit "/drone/image","/image/#{Math.random()}"
    setTimeout ->
      imageSendingPaused = false
    , 100

app.get "/image/:id", (req,res)->
  imageMiddleware currentImg, (err, modifiedImg)->
    res.writeHead 200,"Content-Type": "image/png"
    res.end modifiedImg, "binary"
