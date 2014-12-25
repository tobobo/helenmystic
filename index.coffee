express = require 'express'
compression = require 'compression'

build = require './app/utils/build'
Brocfile = require './Brocfile'

app = express()

app.use compression()

build Brocfile
.then (directory) ->
  app.use express.static(directory)

  app.listen (port = process.env.PORT or 3000), ->
    console.log "app listening on port #{port}..."
.catch (error) ->
  console.log 'app error', error, error.stack
