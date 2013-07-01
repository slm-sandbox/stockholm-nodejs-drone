function VideoController($scope, socket, keyCommands) {

  $scope.init = function () {
    $scope.copterStream = new NodecopterStream(document.querySelector('#dronestream'), {
      hostname: "localhost",
      port: "5000"
    });
  }
  $scope.init()

}
