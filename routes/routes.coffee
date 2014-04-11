
_ = require 'underscore'
multipart = require 'connect-multiparty'
fs = require 'fs'
uuid = require 'node-uuid'

# Dependencies

IconProxy = require('../lib/icon-proxy').IconProxy

# validFileSizeUpper = 353453
validFileSizeUpper = 5242880
validFileTypes = ['image/jpeg','image/jpg','image/png','image/gif']

module.exports = (app)->
  # Homepage
  app.get '/', (req, res) ->
    console.log req.session.messages
    res.render 'index',
      title: "Home"
      messages: req.session.messages
      token: req.csrfToken()

  app.post '/', multipart(), (req, res, next)->
    iconFile = req.files['icon-file']

    validType = true
    validSize = true

    if !isValidFileType(iconFile.type)
      validType = false
      req.session.messages.push 'File is not a valid type.'

    if !isValidFileSize(iconFile.size)
      validSize = false
      req.session.messages.push 'File is not a valid size.'

    if validType && validSize
      # read the uploaded file
      fs.readFile iconFile.path, (err, data)->
        newFolderPath = __dirname + '/../uploads/' + uuid.v4()
        newPath = newFolderPath + '/' + iconFile.originalFilename
        # create a new folder
        fs.mkdir newFolderPath, '0755', ()->
          # write a new file
          fs.writeFile newPath, data, (err)->
            if err
              req.session.messages.push 'An error occurred. ' + err
              console.error err

            icon = new IconProxy()
            # icon.init source: newPath, name:(process.argv[3] || '')
            icon.init source: newPath, name: ''

            icon.readFile()

            res.redirect '/'
      console.log 'saveFile'
      return

    res.redirect '/'
    return

isValidFileSize = (fileSize)->
  return if fileSize < validFileSizeUpper && fileSize > 0 then true else false

isValidFileType = (fileType)->
  pass = false
  validFileTypes.forEach (item, i) ->
    pass = true if item == fileType
  pass


