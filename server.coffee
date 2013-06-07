http = require "http"
express = require "express"
socketio = require "socket.io"
controller = require "./controller"
arDrone = require "ar-drone"

app = do express
httpServer = http.createServer app
httpServer.listen 3000
io = socketio.listen httpServer
io.set "log level", 2
client = arDrone.createClient()

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

