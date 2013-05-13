client = null
exports.init = (_client) ->
  client = _client

exports.takeoff = ->
  client.takeoff()

exports.land = ->
  client.stop()
  client.land()

exports.stop = ->
  client.stop()

upLastUsed = 0
exports.up = ->
  upLastUsed = Date.now()
  client.up 1
  setTimeout ->
    if Date.now() - upLastUsed >40
      client.up 0
  , 50

downLastUsed = 0
exports.down = ->
  downLastUsed = Date.now()
  client.down 1
  setTimeout ->
    if Date.now() - downLastUsed >40
      client.down 0
  , 50

clockwiseLastUsed = 0
exports.clockwise = ->
  clockwiseLastUsed = Date.now()
  client.clockwise 1
  setTimeout ->
    if Date.now() - clockwiseLastUsed >40
      client.clockwise 0
  , 50

counterClockwiseLastUsed = 0
exports.counterClockwise = ->
  counterClockwiseLastUsed = Date.now()
  client.counterClockwise 1
  setTimeout ->
    if Date.now() - counterClockwiseLastUsed >40
      client.counterClockwise 0
  , 50

frontLastUsed = 0
exports.front = ->
  frontLastUsed = Date.now()
  client.front 1
  setTimeout ->
    if Date.now() - frontLastUsed >40
      client.front 0
  , 50

backLastUsed = 0
exports.back = ->
  backLastUsed = Date.now()
  client.back 1
  setTimeout ->
    if Date.now() - backLastUsed >40
      client.back 0
  , 50


rightLastUsed = 0
exports.right = ->
  rightLastUsed = Date.now()
  client.right 1
  setTimeout ->
    if Date.now() - rightLastUsed >40
      client.right 0
  , 50

leftLastUsed = 0
exports.left = ->
  leftLastUsed = Date.now()
  client.left 1
  setTimeout ->
    if Date.now() - leftLastUsed >40
      client.left 0
  , 50

exports.flipLeft = ->
  client.animate "flipLeft", 1500

exports.flipRight = ->
  client.animate "flipRight", 1500

exports.vzDance = ->
  client.animate "vzDance", 1500

exports.disableEmergency = ->
  client.disableEmergency()
