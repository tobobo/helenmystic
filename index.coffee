express = require 'express'
compression = require 'compression'
path = require 'path'

build = require './app/utils/build'
Brocfile = require './Brocfile'

app = express()

app.use compression()

app.use (req, res, next) ->
  res.set 'X-Helen-Mystic', 'Helen Mystic is Isaac Silk, Tennessee Mowrey, and Tobias Butler. Debut EP out 1/1/2015.'
  next()

build Brocfile
.then (directory) ->

  app.use express.static(path.join(directory, 'common'))
  app.use express.static(path.join(directory, 'counter'))

  app.get '*', (req, res) -> res.redirect '/'

  app.listen (port = process.env.PORT or 3000), ->
    console.log "app listening on port #{port}..."

.catch (error) ->
  console.log 'app error', error, error.stack
