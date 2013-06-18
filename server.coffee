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

# require('./imageServer')(client.getPngStream())

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
  client.getPngStream().on 'data', (frame)->

    currentImg = frame
    return if imageSendingPaused
    socket.emit "/drone/image","/image/#{Math.random()}"
    imageSendingPaused = true
    setTimeout ->
      imageSendingPaused = false
    , 100

app.get "/image/:id", (req,res)->
  imageMiddleware currentImg, (err, modifiedImg)->
    res.writeHead 200,"Content-Type": "image/png"
    res.end modifiedImg, "binary"
