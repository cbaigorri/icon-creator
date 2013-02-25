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

  init: ()->
    if process.argv.length > 2
      @iconSource = process.argv[2]
      iconDir = @iconSource.substring 0, @iconSource.lastIndexOf('/')
      # define a name for the icons
      if process.argv[3]
        iconName = process.argv[3]
      else 
        iconName = @iconSource.substring (@iconSource.lastIndexOf('/')+1), @iconSource.lastIndexOf('.')
    else
      console.error 'No Icon - nothing to do!'
      process.exit 1
    
    @impl = new IconImplementation()
    @impl.iconDir = iconDir
    @impl.iconName = iconName
    @

  readFile: ()->
    @impl.readFile @iconSource, [{w:144, h:144}, {w:114, h:114}, {w:72, h:72}, {w:57, h:57}]

    ###
    # Canvas implementation
    impl = @impl
    impl.readFile @iconSource, (img, oIconCanvas) ->
      impl.drawIcon i, img, oIconCanvas for i in [{w:144, h:144}, {w:114, h:114}, {w:72, h:72}, {w:57, h:57}]
    ###
    @
  