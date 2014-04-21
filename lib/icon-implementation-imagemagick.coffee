###
IconImplementation
###

im = require 'imagemagick'
path = require 'path'

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
        icons.push path.normalize(iconPath)
        callback(icons) if totalDrawn == totalImgs
      i++
    @

  drawIcon: (src, i, callback) ->
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
    if (i.format == 'ico')
      args.format = 'ico'
      # args.dstPath = @iconDir + '/' + @iconName + '' + i.w + 'x' + i.h + '.ico'
      args.dstPath = @iconDir + '/' + i.filename
    im.resize args, (err, stdout, stderr) ->
      if (err) then console.error err
      console.log 'Resized and saved in %dms', new Date - start
      callback(args.dstPath)
      return
    @

  createFavicon: (folder, icons, callback) ->
    folder = path.normalize folder
    start = new Date
    im.convert [ path.join(folder, 'favicon16.ico'), path.join(folder, 'favicon24.ico'), path.join(folder, 'favicon32.ico'), path.join(folder, 'favicon48.ico'), path.join(folder, 'favicon64.ico'), path.join(folder, 'favicon.ico') ], (err, stdout) ->
      return callback err if err
      console.log 'Multires ico created and saved in %dms', new Date - start
      callback()
      return
    @
