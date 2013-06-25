function BasicController($scope, socket, keyCommands) {

  $scope.commands = keyCommands.get();

  $scope.disableEmergency = function () {
    socket.emit('cmd', { cmd: 'disableEmergency' });
  };

  socket.on("navdata", function(data) {
    $scope.navdata = data;
  });

}
