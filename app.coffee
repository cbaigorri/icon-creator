###
Icon Creator
###

express = require 'express'
lessMiddleware = require 'less-middleware'
browserify = require 'browserify-middleware'
coffeeify = require 'coffeeify'
path = require 'path'
fs = require 'fs'
rimraf = require 'rimraf'
CronJob = require('cron').CronJob
redis = require 'redis'

class IconCreator

  constructor: ()->
    return

  initialize: ()->
    @initializeConfigurations()
    @initializeRoutes()
    @app.listen 3000, ()->
      console.log 'listening on port 3000'
      return
    # @initializeCronJobs()
    # @cleanUpUploadsFolder()
    @initLogging()
    return

  ###
  Configurations
  ###
  initializeConfigurations: ()->
    logger = require 'morgan'
    cookieParser = require 'cookie-parser'
    methodOverride = require 'method-override'
    bodyParser = require 'body-parser'
    multipart = require 'connect-multiparty'
    # session = require 'express-session'
    session = require 'cookie-session'
    csrf = require 'csurf'

    @app = express()

    @app.set 'title', 'Website Favicon Creator'
    @app.set 'views', __dirname + '/views'
    @app.set 'view engine', 'jade'

    @app.locals.layout = true

    browserify.settings 'transform', [coffeeify]

    @app.use logger()
    @app.use cookieParser()
    @app.use methodOverride()
    @app.use session
      keys: ['asterix', 'cat']
    @app.use multipart()
    @app.use bodyParser()
    @app.use csrf()
    @app.use lessMiddleware path.join(__dirname, 'src', 'less'),
        dest: path.join(__dirname, 'out')
        preprocess:
          path: (pathname, req)->
            return pathname.replace '/stylesheets', ''
      ,
        { }
      ,
        yuicompress: (process.env.NODE_ENV is 'production')
        compress: (process.env.NODE_ENV is 'production')
    @app.use express.static(path.join(__dirname, 'out'))
    @app.use '/uploads', express.static(path.join(__dirname, 'uploads'))
    @app.use (req, res, next)->
      session = req.session
      messages = session.messages || (session.messages = [])

      req.flash = (type, message)->
        messages.push [type, message]

      next()
      return

    @app.get '/js/client.js', browserify('./src/client/client.coffee')

    env = process.env.NODE_ENV || 'development'
    # Development
    if env == 'development'
      @app.locals.pretty = true
    # Production
    else
      @app.locals.pretty = false
    return

  ###
  Routes
  ###
  initializeRoutes: ()->
    require('./routes/routes')(@app)
    return

  ###
  Logging
  ###
  initLogging: ()->
    @client = redis.createClient()
    @client.on "error", (err) ->
      console.error "error event - " + @client.host + ":" + @client.port + " - " + err

  ###
  Cleanup
  ###
  cleanUpUploadsFolder: ()->
    uploadsDir = __dirname + '/uploads'
    fs.readdir uploadsDir, (err, files)->
      files.forEach (file, index)->
        fs.stat path.join(uploadsDir, file), (err, stat)->
          return console.error err if err
          now = new Date().getTime()
          endTime = new Date(stat.ctime).getTime() + 3600000 # 1 hour
          # endTime = new Date(stat.ctime).getTime() + 60000 # 1 minute
          if now > endTime
            rimraf path.join(uploadsDir, file), (err)->
              return console.error err if err
              console.log 'successfully deleted'
              return
          return


  ###
  Cron
  ###
  initializeCronJobs: ()->
    # seconds - minutes - hour - day of month - month - day of week
    # 0 0 0 * * *
    @cleanupJob = new CronJob
      cronTime: '0 * * * * *'
      onTick: ()=>
        console.log 'cleaning uploads...'
        @cleanUpUploadsFolder()
    @cleanupJob.start()


ic = new IconCreator()
ic.initialize()

return
