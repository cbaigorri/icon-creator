###
IconProxy
###

IconImplementation = require('./icon-implementation-imagemagick').IconImplementation

exports.IconProxy = IconProxy = ()->
  # creation
  @iconSource = ''
  @impl
  @

IconProxy.prototype =

  init: (options) ->
    @iconSource = options.source
    iconDir = @iconSource.substring 0, @iconSource.lastIndexOf('/')
    # define a name for the icons
    if options.name
      iconName = options.name
    else
      iconName = @iconSource.substring (@iconSource.lastIndexOf('/')+1), @iconSource.lastIndexOf('.')

    @impl = new IconImplementation(iconDir, iconName)
    @

  readFile: (callback) ->
    @impl.readFile @iconSource, [
        w:310
        h:310
        filename: 'largetile.png'
      ,
        w:310
        h:150
        filename: 'widetile.png'
      ,
        w:152
        h:152
        filename: 'apple-touch-icon-152x152-precomposed.png'
      ,
        w:150
        h:150
        filename: 'mediumtile.png'
      ,
        w:144
        h:144
        filename: 'apple-touch-icon-144x144-precomposed.png'
      ,
        w:120
        h:120
        filename: 'apple-touch-icon-120x120-precomposed.png'
      ,
        w:114
        h:114
        filename: 'apple-touch-icon-114x114-precomposed.png'
      ,
        w:76
        h:76
        filename: 'apple-touch-icon-76x76-precomposed.png'
      ,
        w:72
        h:72
        filename: 'apple-touch-icon-72x72-precomposed.png'
      ,
        w:70
        h:70
        filename: 'smalltile.png'
      ,
        w:57
        h:57
        filename: 'apple-touch-icon.png'
      ,
        w:16
        h:16
        filename: 'favicon.ico'
      ], (icons)->
      callback(icons)
    @

