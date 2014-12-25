filterCoffeescript = require 'broccoli-coffee'
mergeTrees = require 'broccoli-merge-trees'
browserify = require 'broccoli-browserify'
pickFiles = require 'broccoli-static-compiler'
concat = require 'broccoli-concat'

vendorScripts = concat '.',
  inputFiles: [
    'bower_components/moment/min/moment.min.js'
  ]
  outputFile: '/vendor.js'

client = 'app/client'

appScripts = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.coffee']

appScripts = filterCoffeescript appScripts

appScripts = browserify appScripts,
  entries: ['./index']
  outputFile: 'index.js'

html = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.html']

module.exports = mergeTrees [vendorScripts, appScripts, html]
