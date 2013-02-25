###
Icon Creator
###


# Dependencies

IconProxy = require(__dirname + '/lib/icon-proxy').IconProxy

# Initialize

icon = new IconProxy()
icon.init()


# Read the original icon

icon.readFile()
