filterCoffeescript = require 'broccoli-coffee'
mergeTrees = require 'broccoli-merge-trees'
browserify = require 'broccoli-browserify'
pickFiles = require 'broccoli-static-compiler'
uglifyJS = require 'broccoli-uglify-js'
cleanCSS = require 'broccoli-clean-css'
concat = require 'broccoli-concat'

client = 'app/client'

appScripts = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.coffee']

appScripts = filterCoffeescript appScripts

appScripts = browserify appScripts,
  entries: ['./index']
  outputFile: 'app.js'

appStyles = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.css']

appStyles = concat appStyles,
  inputFiles: ['index.css']
  outputFile: '/app.css'

if process.env.NODE_ENV == 'production'
  appScripts = uglifyJS appScripts,
    mangle: true

  appStyles = cleanCSS appStyles

html = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.html']

staticFiles = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['favicon.ico']

module.exports = mergeTrees [html, staticFiles, appScripts, appStyles]
