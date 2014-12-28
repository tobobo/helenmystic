filterCoffeescript = require 'broccoli-coffee'
mergeTrees = require 'broccoli-merge-trees'
browserify = require 'broccoli-browserify'
pickFiles = require 'broccoli-static-compiler'
uglifyJS = require 'broccoli-uglify-js'
cleanCSS = require 'broccoli-clean-css'
concat = require 'broccoli-concat'
inlineAssets = require './utils/broccoli-inline-assets'

client = 'app/client'
counter = client + '/counter'

appScripts = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.coffee', '**/*.js']

appScripts = filterCoffeescript appScripts

counterScripts = browserify appScripts,
  entries: ['./counter/index']
  outputFile: 'counter/index.js'

appStyles = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.css']

appStyles = concat appStyles,
  inputFiles: ['counter/index.css']
  outputFile: '/counter/index.css'

if process.env.NODE_ENV == 'production'
  appScripts = uglifyJS appScripts,
    mangle: true

  appStyles = cleanCSS appStyles

html = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.html']

commonFiles = pickFiles client,
  srcDir: '/'
  destDir: '/common'
  files: ['favicon.ico']

counterAssets = mergeTrees [html, appScripts, appStyles]

counterAssets = inlineAssets counterAssets,
  files:
    'counter/index.html': ['index.js', 'index.css']

counterAssets = pickFiles counterAssets,
  srcDir: '/counter'
  destDir: '/counter'
  files: ['index.html']

mergedAssets = mergeTrees [commonFiles, counterAssets]

module.exports = mergedAssets
