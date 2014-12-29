express = require 'express'
compression = require 'compression'
path = require 'path'

build = require './app/utils/build'
Brocfile = require './Brocfile'

config = require('./config')()

app = express()

app.set 'config', config

app.use compression()

app.use (req, res, next) ->
  res.set 'X-Helen-Mystic', 'Helen Mystic is Isaac Silk, Tennessee Mowrey, and Tobias Butler. Debut EP out 1/1/2015.'
  next()

build Brocfile
.then (directory) ->

  app.use express.static(path.join(directory, 'common'))

  app.use (req, res, next) ->
    if new Date() < app.get('config').endDate
      express.static(path.join(directory, 'counter')) req, res, next
    else
      res.send 'howdy'

  app.get '*', (req, res) -> res.redirect '/'

  port = app.get('config').port
  app.listen port, ->
    console.log "app listening on port #{port}..."

.catch (error) ->
  console.log 'app error', error, error.stack
