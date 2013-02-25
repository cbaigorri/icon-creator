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
    console.log i
    start = new Date
    im.resize
      srcPath: src
      dstPath: @iconDir + '/' + @iconName + '' + i.w + 'x' + i.h + '.png'
      width: i.w
      height: i.h
    , (err, stdout, stderr) ->
      if (err) then throw err
      console.log 'Resized and saved in %dms', new Date - start
    @
