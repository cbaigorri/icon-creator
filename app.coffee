###
Icon Creator
###


# Dependencies

IconProxy = require(__dirname + '/lib/icon-proxy').IconProxy


# Check for something to convert

if process.argv.length < 3
  console.error 'No Icon - nothing to do!'
  process.exit 1

# Initialize

icon = new IconProxy()
icon.init source: process.argv[2], name:(process.argv[3] || '')


# Read the original icon

icon.readFile()
