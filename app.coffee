###
TODO: add node-imagemagick implementation
      
###


###
Module Dependencies
###

IconProxy = require(__dirname + '/lib/icon-proxy').IconProxy

###
Check for icon
###

icon = new IconProxy()
icon.init()


###
Read the original icon
###

icon.readFile()

