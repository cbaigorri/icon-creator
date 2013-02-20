###
IconImplementation
###

Canvas = require 'canvas'
Image = Canvas.Image
fs = require 'fs'

IconImplementation = ()->
  # creation
  @iconSource = ''
  @iconDir = ''
  @

IconImplementation.prototype = 
  init: ()->
    console.log 'init'
    @



exports.IconImplementation = new IconImplementation()
