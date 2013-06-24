
angular.module('utils', []).provider('socket', function() {
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
