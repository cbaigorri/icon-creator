
_ = require 'underscore'
multipart = require 'connect-multiparty'
fs = require 'fs'
uuid = require 'node-uuid'
path = require 'path'
AdmZip = require('adm-zip')
archiver = require 'archiver'

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
      iconToken: req.query['icon-token'] || undefined

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
        folderId = uuid.v4()
        newFolderPath = __dirname + '/../uploads/' + folderId
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

            # all files have been saved
            icon.readFile (icons)->

              # create favicon
              icon.createFavicon newFolderPath, icons, (err)->
                return console.error err if err
                # remove unused files
                removeUnusedFiles newFolderPath, ()->
                  console.log 'back from removing old files'
                # create zip
                createZip(newFolderPath, icons)
                # redirect
                res.redirect '/?icon-token='+folderId

            return
          return
        return
    else
      res.redirect '/'
    return
  return

isValidFileSize = (fileSize)->
  return if fileSize < validFileSizeUpper && fileSize > 0 then true else false

isValidFileType = (fileType)->
  pass = false
  validFileTypes.forEach (item, i) ->
    pass = true if item == fileType
  pass

createZip = (folderPath, icons)->
  filesToZip = ['apple-touch-icon-72x72-precomposed.png', 'apple-touch-icon-76x76-precomposed.png', 'apple-touch-icon-114x114-precomposed.png', 'apple-touch-icon-120x120-precomposed.png', 'apple-touch-icon-144x144-precomposed.png', 'apple-touch-icon-152x152-precomposed.png', 'apple-touch-icon.png', 'favicon.ico', 'largetile.png', 'mediumtile.png', 'smalltile.png', 'widetile.png']
  # filesToZip = ['apple-touch-icon-72x72-precomposed.png', 'apple-touch-icon-76x76-precomposed.png', 'apple-touch-icon-114x114-precomposed.png', 'apple-touch-icon-120x120-precomposed.png', 'apple-touch-icon-144x144-precomposed.png', 'apple-touch-icon-152x152-precomposed.png', 'apple-touch-icon.png', 'favicon.ico', 'largetile.png', 'mediumtile.png', 'smalltile.png', 'widetile.png']
  # filesToZip = ['apple-touch-icon-72x72-precomposed.png', 'apple-touch-icon-76x76-precomposed.png', 'apple-touch-icon-114x114-precomposed.png', 'apple-touch-icon-152x152-precomposed.png', 'apple-touch-icon.png', 'favicon.ico', 'largetile.png', 'smalltile.png']
  # filesToZip = ['apple-touch-icon-120x120-precomposed.png', 'apple-touch-icon-144x144-precomposed.png', 'mediumtile.png', 'widetile.png']
  # filesToZip = ['apple-touch-icon.png', 'favicon.ico', 'largetile.png', 'smalltile.png']

  output = fs.createWriteStream path.join(folderPath, 'website-icons.zip')
  archive = archiver 'zip'

  output.on 'close', () ->
    console.log archive.pointer(), 'total bytes'
    console.log 'archiver has been finalized and the output file descriptor has closed.'

  archive.on 'error', (err)->
    throw err

  archive.pipe output

  i = 0
  icons.push path.join(folderPath, 'favicon.ico') # add regular ico
  while i < icons.length
    filesToZip.forEach (f, j)->
      if icons[i] == path.join(folderPath, f)
        console.log icons[i]
        archive.append fs.createReadStream(icons[i]), name: path.basename(icons[i])
    i++

  archive.finalize()

  return


  zip = new AdmZip()
  i = 0
  folderPath = path.normalize(folderPath)
  icons.push path.join(folderPath, 'favicon.ico') # add regular ico
  while i < icons.length
    filesToZip.forEach (f, j)->
      if icons[i] == path.join(folderPath, f)
        console.log 'adding to zip:', icons[i]
        zip.addLocalFile icons[i]
    i++
  zip.writeZip path.join(folderPath, 'website-icons.zip')
  return

removeUnusedFiles = (folderPath, callback)->
  filesDeleted = 0
  filesToDelete = ['favicon64.ico', 'favicon48.ico', 'favicon32.ico', 'favicon24.ico', 'favicon16.ico']
  fs.readdir folderPath, (err, files)->
    files.forEach (file, index)->
      fs.stat path.join(folderPath, file), (err, stat)->
        return console.error err if err
        filesToDelete.forEach (f, i)->
          if f == file
            fs.unlink path.join(folderPath, file), ()->
              console.log 'file deleted'
              if ++filesDeleted == filesToDelete.length then callback()

