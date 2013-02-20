###
TODO: add node-imagemagick implementation
      
###


###
Module Dependencies
###

IconImplementation = require __dirname + '/lib/icon-implementation'

###
Check for icon
###

console.log IconImplementation

return false

###
Read the original icon
###

IconImplementation.readFile ->
  IconImplementation.drawIcon i, img for i in [{w:144, h:144}, {w:114, h:114}, {w:72, h:72}, {w:57, h:57}]


