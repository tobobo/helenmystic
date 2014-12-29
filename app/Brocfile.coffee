filterCoffeescript = require 'broccoli-coffee'
mergeTrees = require 'broccoli-merge-trees'
browserify = require 'broccoli-browserify'
pickFiles = require 'broccoli-static-compiler'
uglifyJS = require 'broccoli-uglify-js'
cleanCSS = require 'broccoli-clean-css'
concat = require 'broccoli-concat'
replace = require 'broccoli-string-replace'
inlineAssets = require './utils/broccoli-inline-assets'

config = require('../config')()
client = 'app/client'

counterScripts = pickFiles client,
  srcDir: '/'
  destDir: '/'
  files: ['**/*.coffee']

counterScripts = replace counterScripts,
  files: ['config.coffee']
  patterns: [
    match: /\{\{\{COUNTER_CONFIG\}\}\}/
    replacement: JSON.stringify config.client
  ]

counterScripts = filterCoffeescript counterScripts

counterScripts = browserify counterScripts,
  entries: ['./counter/index']
  outputFile: 'counter/index.js'

counterStyles = pickFiles client,
  srcDir: '/counter'
  destDir: '/counter'
  files: ['**/*.css']

counterStyles = concat counterStyles,
  inputFiles: ['counter/index.css']
  outputFile: '/counter/index.css'

if process.env.NODE_ENV == 'production'
  counterScripts = uglifyJS counterScripts,
    mangle: true

  counterStyles = cleanCSS counterStyles

counterHTML = pickFiles client,
  srcDir: '/counter'
  destDir: '/counter'
  files: ['**/*.html']

counterAssets = mergeTrees [counterHTML, counterScripts, counterStyles]

counterAssets = inlineAssets counterAssets,
  files:
    'counter/index.html': ['index.js', 'index.css']

counterAssets = pickFiles counterAssets,
  srcDir: '/counter'
  destDir: '/counter'
  files: ['index.html']

commonFiles = pickFiles client,
  srcDir: '/'
  destDir: '/common'
  files: ['favicon.ico']

mergedAssets = mergeTrees [commonFiles, counterAssets]

module.exports = mergedAssets
