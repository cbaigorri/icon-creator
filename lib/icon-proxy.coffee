###
IconProxy
###

IconImplementation = require(__dirname + '/icon-implementation-imagemagick').IconImplementation

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

  readFile: () ->
    @impl.readFile @iconSource, [{w:144, h:144}, {w:114, h:114}, {w:72, h:72}, {w:57, h:57}, {w:16, h:16}]
    @
  