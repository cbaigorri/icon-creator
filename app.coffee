###
Module Dependencies
###

Canvas = require 'canvas'
Image = Canvas.Image
fs = require 'fs'

###
Check for icon
###

if process.argv.length >= 2
  iconSource = process.argv[2]
  iconDir = iconSource.substring 0, iconSource.lastIndexOf('/')
  # define a name for the icons
  if process.argv[3]
    iconName = process.argv[3]
  else 
    iconName = iconSource.substring (iconSource.lastIndexOf('/')+1), iconSource.lastIndexOf('.')
else
  console.error 'No Icon - nothing to do!'
  process.exit 1


###
Draw the icons
###

drawIcon = (i, img) ->
  console.log i 
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

  out = fs.createWriteStream iconDir + '/' + iconName + '' + w + 'x' + h + '.png'
  stream = canvas.createPNGStream()

  ###
  canvas.toBuffer (err, buf) ->
    fs.writeFile iconDir + '/' + iconName + '' + w + 'x' + h + '.png', buf, ()->
      console.log 'Resized and saved in %dms', new Date - start
  ###

  stream.on 'data', (chunk) ->
    out.write chunk
    @

  @


###
Read the original icon
###

oIconCanvas = new Canvas 1, 1
oIconCtx = oIconCanvas.getContext '2d'  

fs.readFile iconSource, (err, icon) ->
  if (err) then throw err
  img = new Image
  img.src = icon

  oIconCanvas = new Canvas img.width, img.height
  oIconCtx = oIconCanvas.getContext '2d'

  oIconCtx.drawImage img, 0, 0, img.width, img.height
  
  drawIcon i, img for i in [{w:144, h:144}, {w:114, h:114}, {w:72, h:72}, {w:57, h:57}]


