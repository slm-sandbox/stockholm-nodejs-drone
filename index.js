var http = require('http');
var express = require('express');
var socketio = require('socket.io');
var controller = require('./controller');
var arDrone = require('ar-drone');

var app = express();
var httpServer = http.createServer(app);
httpServer.listen(3000);
var io = socketio.listen(httpServer);

var client = arDrone.createClient();
controller.init(client);

app.configure(function () {
  app.set('views', __dirname + '/client');
  app.set('view engine', 'jade');
  app.use('/assets', express.static(__dirname + '/client/assets'));
});

app.get('/', function(req, res) {
  res.render('index');
});

io.sockets.on('connection', function (socket) {
  socket.on('cmd', function (data) {
    var action = controller[data.cmd];
    if (action) {
      console.log(data.cmd);
      action();
    } else {
      console.log('unknown function: ' + data.cmd);
    }
  });

  client.on('navdata', function (data) { socket.emit('navdata', data); });
});
