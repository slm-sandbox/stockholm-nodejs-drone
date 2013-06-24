
function BasicController($scope, socket) {

    //     window.$scope = $scope;

  $scope.disableEmergency = function () {
    socket.emit('cmd', { cmd: 'disableEmergency' });
  };

  var navdata = document.getElementById("navdata");
  socket.on("navdata", function(data) {
    $scope.navdata = data;
    $scope.$digest();
    function navdataObject2String (object) {
      var v;
      s = "";
      for (k in object) {
        v = object[k];
        s = s + k + ": " + v + "<br/>";
      }
      return s;
    }
    navdata.innerHTML = navdataObject2String(data.droneState) + navdataObject2String(data.demo);
  });

  var table = document.getElementById('commands');
  function on (combo, cmd) {
    KeyboardJS.on(combo, function() { socket.emit("cmd", { "cmd": cmd }); });
    var row = document.createElement("TR");
    row.insertCell(0).innerHTML = combo;
    row.insertCell(1).innerHTML = cmd;
    table.appendChild(row);
  }
  on('a', 'takeoff');
  on('z', 'land');
  on('s', 'up');
  on('x', 'down');
  on('q', 'clockwise');
  on('w', 'counterClockwise');
  on('up', 'front');
  on('down', 'back');
  on('right', 'right');
  on('left', 'left');
  on('k', 'flipLeft');
  on('l', 'flipRight');
  on('o', 'vzDance');
  on('space', 'stop');
}
