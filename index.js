var http        = require('http');
var express     = require('express');
var socketio    = require('socket.io');
var controller  = require('./controller');
var arDrone     = require('ar-drone');
var connectAssets = require('connect-assets');
var droneStream = require("dronestream");

var app = express();

var videoServer = http.createServer(function(req, res) {
    return res;
});
droneStream.listen(videoServer);

var httpServer = http.createServer(app);



var io = socketio.listen(httpServer);
io.set('log level', 2);

var client = arDrone.createClient();
controller.init(client);

app.configure(function () {
  app.set('views', __dirname + '/client/interface');
  app.set('view engine', 'jade');
  app.use( connectAssets({src: "client"}))
});

app.get("/interface/:name", function(req, res) {
  var name = req.params.name;
  res.render(name + '/' + name);
});

app.use(function(req, res) {
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

  client.on('navdata', function (data) {
	  socket.emit('navdata', data);
  });

});

httpServer.listen(3000, function () {
  console.log ("......................................")
  console.log ("Environment set to: " + process.env.NODE_ENV)
  console.log ("Listen to port: " + 3000)
  console.log ("......................................")
});

videoServer.listen(5000, function() {
	console.log ("Video port open");
} );
