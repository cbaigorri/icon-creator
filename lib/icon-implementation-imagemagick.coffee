###
IconImplementation
###

im = require 'imagemagick'

exports.IconImplementation = IconImplementation = ()->
  # creation
  @iconDir = ''
  @iconName = ''
  @

IconImplementation.prototype = 

  readFile: (src, imgs) ->
    @drawIcon src, i for i in imgs
    @
  
  drawIcon: (src, i) ->
    start = new Date
    fileType = src.substring(src.lastIndexOf('.') + 1, src.length)
    args = 
      srcPath: src
      dstPath: @iconDir + '/' + @iconName + '' + i.w + 'x' + i.h + '.png'
      width: i.w
      height: i.h
      srcFormat: fileType
      format: 'png'
    if (i.w is 16 and i.h is 16)
      args.format = 'ico'
      args.dstPath = @iconDir + '/' + @iconName + '' + i.w + 'x' + i.h + '.ico'
    im.resize args, (err, stdout, stderr) ->
      if (err) then throw err
      console.log 'Resized and saved in %dms', new Date - start
    @
