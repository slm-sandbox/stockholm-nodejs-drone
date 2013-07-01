function VideoController($scope, socket, keyCommands) {
	$scope.commands = keyCommands.get();

	$scope.disableEmergency = function () {
		socket.emit('cmd', { cmd: 'disableEmergency' });
	};

	$scope.copterStream = new NodecopterStream(document.querySelector('#dronestream'), {
			hostname: "localhost",
			port: "5000"
		});
}
