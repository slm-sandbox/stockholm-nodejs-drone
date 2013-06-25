
angular.module('utils.socket', []).provider('socket', function() {
  var self;
  self = this;
  self.url = location.origin;
  self.query = null;
  self.reconnectionAttempts = 900;
  this.setUrl = function(url) {
    return self.url = url;
  };
  this.setReconnectionAttempts = function(attempts) {
    return self.reconnectionAttempts = attempts;
  };
  this.setQuery = function(query) {
    return self.query = query;
  };
  this.$get = [
    '$rootScope', function($rootScope) {
      var obj, socket;
      socket = io.connect(self.url, {
        query: self.query,
        secure: /^https/.test(self.url),
        'max reconnection attempts': self.reconnectionAttempts
      });
      obj = {
        on: function(eventName, cb) {
          return socket.on(eventName, function() {
            var args;
            args = arguments;
            return $rootScope.$apply(function() {
              return cb.apply(socket, args);
            });
          });
        },
        once: function(eventName, cb) {
          return socket.once(eventName, function() {
            var args;
            args = arguments;
            return $rootScope.$apply(function() {
              return cb.apply(socket, args);
            });
          });
        },
        emit: function(eventName, data, cb) {
          return socket.emit(eventName, data, function() {
            var args;
            if (cb) {
              args = arguments;
              return $rootScope.$apply(function() {
                return cb.apply(socket, args);
              });
            }
          });
        },
        socket: socket.socket,
        connected: socket.socket.connected
      };
      socket.on('connect', function() {
        return $rootScope.$apply(function() {
          return obj.connected = true;
        });
      });
      socket.on('disconnect', function() {
        return $rootScope.$apply(function() {
          return obj.connected = false;
        });
      });
      return obj;
    }
  ];
  return this;
});


angular.module('utils.keyCommands', ["utils.socket"]).service('keyCommands', function(socket) {

  var commands = {
    "e" : {"down" : "takeoff"},
    "space" : {"down" : "land"},
    "up" : {"down" : "up", "up" : "upStop"},
    "down" : {"down" : "down", "up" : "downStop"},
    "right" : {"down" : "clockwise", "up" : "clockwiseStop"},
    "left" : {"down" : "counterClockwise", "up" : "counterClockwiseStop"},
    "w" : {"down" : "front", "up" : "frontStop"},
    "s" : {"down" : "back", "up" : "backStop"},
    "d" : {"down" : "right", "up" : "rightStop"},
    "a" : {"down" : "left", "up" : "leftStop"},
    "k" : {"down" : "flipLeft"},
    "l" : {"down" : "flipRight"},
    "o" : {"down" : "vzDance"},
    "q" : {"down" : "stop"}
  };


  this.get = function () {
    return commands;
  };

  this.bind = function (keyboardKey, cmdOnDown, cmdOnUp) {
    Mousetrap.bind(keyboardKey, function() { socket.emit("cmd", { "cmd": cmdOnDown }); }, 'keydown');
    if (cmdOnUp) {
      Mousetrap.bind(keyboardKey, function() { socket.emit("cmd", { "cmd": cmdOnUp }); }, 'keyup');
    }
  };

  this.reset = function() {
    for(var key in commands) {
      this.bind(key, commands[key].down, commands[key].up)
    }
  };

  this.reset()

  return this;

});



angular.module('utils', ["utils.socket", "utils.keyCommands"])


