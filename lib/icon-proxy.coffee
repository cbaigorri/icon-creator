IconImplementation = require(__dirname + '/icon-implementation-canvas').IconImplementation

exports.IconProxy = IconProxy = ()->
  # creation
  @iconSource = ''
  @iconDir = ''
  @iconName = ''
  @impl
  @

IconProxy.prototype = 

  init: ()->
    if process.argv.length > 2
      @iconSource = process.argv[2]
      @iconDir = @iconSource.substring 0, @iconSource.lastIndexOf('/')
      # define a name for the icons
      if process.argv[3]
        @iconName = process.argv[3]
      else 
        @iconName = @iconSource.substring (@iconSource.lastIndexOf('/')+1), @iconSource.lastIndexOf('.')
    else
      console.error 'No Icon - nothing to do!'
      process.exit 1
    
    @impl = new IconImplementation()
    
    @

  readFile: (callback)->
    @impl.readFile @iconSource, callback
    @
  
  drawIcon: (i, img, oIconCanvas)->
    #@impl.drawIcon i, img, oIconCanvas
    @