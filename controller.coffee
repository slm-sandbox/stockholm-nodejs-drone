cv = require 'opencv'
arDrone = require "ar-drone"

lastNavData = null

speed = 1

client = null
pngStream = null
exports.init = (_client) ->
  client = _client

  pngStream = client.getPngStream()

  lastError = null
  pngStream.on("error", (e)->
    console.log(e)
    lastError = e

    ).on "data", (pngBuffer) ->
    if lastError?
      console.log lastError
    lastPng = pngBuffer
    if (not processingImg) and lastPng
      # console.log 'detectFaces:', detectFaces
      # console.log 'processingImg:', processingImg
      processingImg = true
      cv.readImage lastPng, (err, im) ->
        im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->
          sortFaces = faces.sort (a,b)->
            b.width*b.height-a.width*a.height
          face = sortFaces[0]
          if detectFaces and face
            seekFace face, im, ()->
              processingImg = false
          else
            processingImg = false
            client.clockwise 0





exports.takeoff = ->
  client.takeoff()

exports.land = ->
  client.stop()
  client.land()

exports.stop = ->
  detectFaces = false
  client.stop()

upLastUsed = 0
exports.up = ->
  upLastUsed = Date.now()
  client.up speed
  setTimeout ->
    if Date.now() - upLastUsed >200
      client.up 0
  , 250

downLastUsed = 0
exports.down = ->
  downLastUsed = Date.now()
  client.down speed
  setTimeout ->
    if Date.now() - downLastUsed >200
      client.down 0
  , 250

clockwiseLastUsed = 0
exports.clockwise = ->
  clockwiseLastUsed = Date.now()
  client.clockwise speed
  setTimeout ->
    if Date.now() - clockwiseLastUsed >200
      client.clockwise 0
  , 250

counterClockwiseLastUsed = 0
exports.counterClockwise = ->
  counterClockwiseLastUsed = Date.now()
  client.counterClockwise speed
  setTimeout ->
    if Date.now() - counterClockwiseLastUsed >200
      client.counterClockwise 0
  , 250

frontLastUsed = 0
exports.front = ->
  frontLastUsed = Date.now()
  client.front speed
  setTimeout ->
    if Date.now() - frontLastUsed >200
      client.front 0
  , 250

backLastUsed = 0
exports.back = ->
  backLastUsed = Date.now()
  client.back speed
  setTimeout ->
    if Date.now() - backLastUsed >200
      client.back 0
  , 250


rightLastUsed = 0
exports.right = ->
  rightLastUsed = Date.now()
  client.right speed
  setTimeout ->
    if Date.now() - rightLastUsed >200
      client.right 0
  , 250

leftLastUsed = 0
exports.left = ->
  leftLastUsed = Date.now()
  client.left speed
  setTimeout ->
    if Date.now() - leftLastUsed >200
      client.left 0
  , 250

exports.flipLeft = ->
  client.animate "flipLeft", 1000

exports.flipRight = ->
  client.animate "flipRight", 1000

exports.vzDance = ->
  client.animate "vzDance", 1000

exports.disableEmergency = ->
  client.disableEmergency()


lastPng = null
processingImg = false
detectFaces = false

exports.faceDetection = ->
  detectFaces = true

exports.stopFaceDetection = ->
  detectFaces = false


exports.startFixHeight = ->
  fixHeight = true
exports.endFixHeight = ->
  fixHeight = false


seekFace = (face, im,cb)->
  faceCenter = {
    x: face.x + face.width * 0.5
    y: face.y + face.height * 0.5
  }
  imCenter = {
    x: im.width()*0.5
    y: im.height()*0.5
  }
  console.log 'face',face
  console.log 'im',im
  console.log 'faceCenter', faceCenter
  console.log 'imCenter', imCenter


  turnDiff = 1 - faceCenter.x/imCenter.x
  # heightDiff = 1 - faceCenter.y/imCenter.y

  console.log 'turnDiff',turnDiff
  if turnDiff<-0.1
    console.log 'Goes counterClockwise for face', turnDiff
    # client.counterClockwise 0.1
    console.log 'client.counterClockwise 1'
  else if turnDiff>0.1

    console.log 'Goes clockwise for face', turnDiff
    # client.clockwise 0.1
    console.log 'client.clockwise 1'
  else
    client.clockwise 0
