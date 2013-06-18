cv = require 'opencv'
arDrone = require "ar-drone"

lastNavData = null

speed = 1

client = null
pngStream = null
lastPng = null
detectFaces = false

exports.imageMiddlewares = [
  (frame,cb)->
    cv.readImage frame, (err, im) ->
      if err?
        console.log err
        cb err
      im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->
        if err?
          console.log err
          cb err

        for face in faces
          console.log face
          im.ellipse face.x + face.width / 2, face.y + face.height / 2, face.width / 2, face.height / 2, null, 'green'
        cb null, im.toBuffer()
]


seekFace = (face, im,cb)->
  faceCenter = {
    x: face.x + face.width * 0.5
    y: face.y + face.height * 0.5
  }
  imCenter = {
    x: im.width()*0.5
    y: im.height()*0.5
  }

  turnDiff = 1 - faceCenter.x/imCenter.x
  heightDiff = 1 - faceCenter.y/imCenter.y

  seekHeight = (cb)->
    console.log 'turnDiff',turnDiff
    if turnDiff<-0.1
      console.log 'Goes clockwise for face', turnDiff
      client.clockwise( 0.1).after 100, ->
        do cb
      console.log 'client.clockwise 1'
    else if turnDiff>0.1
      console.log 'Goes counterClockwise for face', turnDiff
      client.counterClockwise( 0.1).after 100, ->
        do cb
      console.log 'client.counterClockwise 1'
    else
      client.stop().after 100, ->
        do cb

  seekTurn = (cb)->
    console.log 'heightDiff',heightDiff
    if heightDiff<-0.1
      console.log 'Goes down for face', heightDiff
      client.down(0.1).after 100, ->
        do cb
      console.log 'client.down 0.1'
    else if heightDiff>0.1
      console.log 'Goes up for face', heightDiff
      client.up(0.1).after 100, ->
        do cb
      console.log 'client.up 0.1'
    else
      client.stop().after 100, ->
        do cb

  if Math.abs(turnDiff)>Math.abs(heightDiff)
    seekTurn cb
  else
    seekHeight cb

missingFaceDetections = 0
reactingToFace = false
detectFace = (pngBuffer)->
  if pngBuffer
    cv.readImage pngBuffer, (err, im) ->
      im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->
        console.log err if err?
        if faces.length>0
          missingFaceDetections = 0
          sortFaces = faces.sort (a,b)->
            b.width*b.height-a.width*a.height
          face = sortFaces[0]
          if detectFaces and not reactingToFace
            reactingToFace = true
            seekFace face, im, ()->
              reactingToFace = false
        else
          missingFaceDetections++
          if detectFaces and missingFaceDetections>10
            client.stop()


exports.init = (_client) ->
  client = _client

  pngStream = client.getPngStream()

  lastError = null
  pngStream.on("error", (e)->
    console.log e

  ).on "data", (pngBuffer) ->
    detectFace pngBuffer

exports.takeoff = ->
  client.takeoff()

exports.land = ->
  client.stop()
  client.land()

exports.stop = ->
  detectFaces = false
  client.stop()

exports.up = ->
  client.up speed

exports.upStop = ->
  client.up 0

exports.down = ->
  client.down speed

exports.downStop = ->
  client.down 0

exports.clockwise = ->
  client.clockwise speed

exports.clockwiseStop = ->
  client.clockwise 0

exports.counterClockwise = ->
  client.counterClockwise speed

exports.counterClockwiseStop = ->
  client.counterClockwise 0

exports.front = ->
  client.front speed

exports.frontStop = ->
  client.front 0

exports.back = ->
  client.back speed

exports.backStop = ->
  client.back 0

exports.right = ->
  client.right speed

exports.rightStop = ->
  client.right 0

exports.left = ->
  client.left speed

exports.leftStop = ->
  client.left 0

exports.flipLeft = ->
  client.animate "flipLeft", 1000

exports.flipRight = ->
  client.animate "flipRight", 1000

exports.vzDance = ->
  client.animate "vzDance", 1000

exports.disableEmergency = ->
  client.land()
  client.disableEmergency()

exports.faceDetection = ->
  detectFaces = true

exports.stopFaceDetection = ->
  detectFaces = false
