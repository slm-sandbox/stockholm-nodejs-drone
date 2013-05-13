http = require "http"
express = require "express"
socketio = require "socket.io"
controller = require "./controller"
arDrone = require "ar-drone"
cv = require 'opencv'

app = do express
httpServer = http.createServer app
httpServer.listen 3000
io = socketio.listen httpServer
io.set "log level", 2
client = arDrone.createClient()
pngStream = arDrone.createPngStream()
controller.init client
app.configure ->
  app.set "views", __dirname + "/client"
  app.set "view engine", "jade"
  app.use "/assets", express.static(__dirname + "/client/assets")

app.get "/", (req, res) ->
  res.render "index"

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

lastPng = null
processingImg = false

seekFace = (face, im,cb)->
  faceCenter = {
    x: face.x + face.width * 0.5
    y: face.y + face.height * 0.5
  }
  imCenter = {
    x: im.width*0.5
    y: im.height*0.5
  }

  turnDiff = 1 - faceCenter.x/imCenter.x
  heightDiff = 1 - faceCenter.y/imCenter.y


  # if Math.abs(heightDiff)>0.1
  if heightDiff<0
    console.log 'Goes down', heightDiff
    client.down 1
  else
    console.log 'Goes up', heightDiff
    client.up 1

  setTimeout ->
    client.up 0
    client.clockwise 0
    do cb
  , 100


pngStream.on("error", console.log).on "data", (pngBuffer) ->
  lastPng = pngBuffer
  if (not processingImg) and lastPng
    processingImg = true
    cv.readImage lastPng, (err, im) ->
      im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->
        sortFaces = faces.sort (a,b)->
          b.width*b.height-a.width*a.height
        face = sortFaces[0]
        if not face
          processingImg = false
          console.log 'No face'
          return

        console.log face
        seekFace face, im, ()->
          processingImg = false

