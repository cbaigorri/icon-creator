###
TODO: add node-imagemagick implementation
      
###


###
Module Dependencies
###

IconImplementation = require(__dirname + '/lib/icon-implementation').IconImplementation

###
Initialize
###

impl = new IconImplementation()
impl.init()


###
Read the original icon
###

impl.readFile (img, oIconCanvas)->
  impl.drawIcon i, img, oIconCanvas for i in [{w:300, h:300}, {w:144, h:144}, {w:114, h:114}, {w:72, h:72}, {w:57, h:57}]
