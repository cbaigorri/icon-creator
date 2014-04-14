###
IconImplementation
###

im = require 'imagemagick'

exports.IconImplementation = IconImplementation = (iconDir, iconName)->
  # creation
  @iconDir = iconDir
  @iconName = iconName
  @

IconImplementation.prototype =

  readFile: (src, imgs, callback) ->
    i = 0
    totalDrawn = 0
    totalImgs = imgs.length
    icons = []
    while i < imgs.length
      @drawIcon src, imgs[i], (iconPath)->
        totalDrawn++
        icons.push iconPath
        callback(icons) if totalDrawn == totalImgs
      i++
    @

  drawIcon: (src, i, callback) ->
    console.log i
    start = new Date
    fileType = src.substring(src.lastIndexOf('.') + 1, src.length)
    args =
      srcPath: src
      # dstPath: @iconDir + '/' + @iconName + '' + i.w + 'x' + i.h + '.png'
      dstPath: @iconDir + '/' + i.filename
      width: i.w
      height: i.h
      srcFormat: fileType
      format: 'png'
    if (i.w is 16 and i.h is 16)
      args.format = 'ico'
      # args.dstPath = @iconDir + '/' + @iconName + '' + i.w + 'x' + i.h + '.ico'
      args.dstPath = @iconDir + '/' + i.filename
    im.resize args, (err, stdout, stderr) ->
      if (err) then console.error err
      console.log 'Resized and saved in %dms', new Date - start
      callback(args.dstPath)
    @
