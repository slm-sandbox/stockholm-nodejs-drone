# Instal opencv by
# brew tap homebrew/science
# brew instal opencv

cv = require 'opencv'

cv.readImage "./test.jpg", (err, im) ->
  im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->
    i = 0

    while i < faces.length
      face = faces[i]
      console.log face
      im.ellipse face.x + face.width / 2, face.y + face.height / 2, face.width / 2, face.height / 2
      i++
    im.save "./out.jpg"

