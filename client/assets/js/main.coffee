socket = io.connect "http://localhost:3000"
window.Ctrl = ($scope) ->



  on_ = (combo, cmd,undoCmd) ->
    Mousetrap.bind combo, ()->
      socket.emit "cmd",
        cmd: cmd
    ,
      'keydown'

    if undoCmd
      Mousetrap.bind combo, ()->
        socket.emit "cmd",
          cmd: undoCmd
      ,
        'keyup'

    row = document.createElement("TR")
    row.insertCell(0).innerHTML = combo
    row.insertCell(1).innerHTML = cmd
    table.appendChild row

  window.$scope = $scope
  $scope.disableEmergency = ->
    socket.emit "cmd",
      cmd: "disableEmergency"


  navdata = document.getElementById("navdata")
  socket.on "navdata", (data) ->
    navdataObject2String = (object) ->
      s = ""
      for k of object
        v = object[k]
        s = s + k + ": " + v + "<br/>"
      s
    $scope.navdata = data
    $scope.$digest()
    navdata.innerHTML = navdataObject2String(data.droneState) + navdataObject2String(data.demo)

  socket.on "/drone/image", (src)->
    $scope.camImg = src
    console.log src
    $scope.$apply()


  table = document.getElementById("commands")
  on_ "e", "takeoff"
  on_ "space", "land"
  on_ "up", "up", "upStop"
  on_ "down", "down", "downStop"
  on_ "right", "clockwise", "clockwiseStop"
  on_ "left", "counterClockwise", "counterClockwiseStop"
  on_ "w", "front", "frontStop"
  on_ "s", "back", "backStop"
  on_ "d", "right", "rightStop"
  on_ "a", "left", "leftStop"
  on_ "k", "flipLeft"
  on_ "l", "flipRight"
  on_ "o", "vzDance"
  on_ "q", "stop"
  on_ "f", "faceDetection"
  on_ "g", "stopFaceDetection"
  on_ "r", "startFixHeight"
  on_ "t", "endFixHeight"
