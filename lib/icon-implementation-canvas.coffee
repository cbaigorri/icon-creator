###
IconImplementation
###

Canvas = require 'canvas'
Image = Canvas.Image
fs = require 'fs'

exports.IconImplementation = IconImplementation = ()->
  # creation
  @iconDir = ''
  @iconName = ''
  @

IconImplementation.prototype = 

  readFile: (src, callback)->
    fs.readFile src, (err, icon) ->
      if (err) then throw err
      img = new Image
      img.src = icon

      oIconCanvas = new Canvas img.width, img.height
      oIconCtx = oIconCanvas.getContext '2d'
      
      oIconCtx.drawImage img, 0, 0, img.width, img.height
      
      callback img, oIconCanvas
  
  drawIcon: (i, img, oIconCanvas)->
    console.log i, img
    start = new Date
    w = i.w
    h = i.h
    ratioW = img.width / w
    ratioH = img.height / h
    width = Math.floor img.width / ratioW
    height = Math.floor img.width / ratioH

    canvas = new Canvas width, height
    ctx = canvas.getContext '2d'

    ctx.clearRect 0, 0, canvas.width, canvas.height

    ctx.patternQuality = "best"
    ctx.antialias = "subpixel"

    ctx.drawImage oIconCanvas, 0, 0, width, height

    ctx.restore()

    out = fs.createWriteStream @iconDir + '/' + @iconName + '' + w + 'x' + h + '.png'
    stream = canvas.createPNGStream()

    ###
    canvas.toBuffer (err, buf) ->
      fs.writeFile iconDir + '/' + iconName + '' + w + 'x' + h + '.png', buf, ()->
        console.log 'Resized and saved in %dms', new Date - start
    ###

    stream.on 'data', (chunk) ->
      out.write chunk
      @

    stream.on 'end', () ->
      console.log 'Resized and saved in %dms', new Date - start
      @

    @
