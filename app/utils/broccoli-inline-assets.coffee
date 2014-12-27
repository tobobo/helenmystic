Filter = require 'broccoli-filter'
cheerio = require 'cheerio'
fs = require 'fs'
path = require 'path'
glob = require 'glob'

class InlineAssets extends Filter

  extensions: ['html']
  targetExtension: 'html'

  constructor: (@inputTree, @options={}) ->
    super inputTree, options
    @extensions = @options.extensions or @extensions
    @targetExtension = @options.targetExtension or @targetExtension

    @html = @options.html
    @assets = @options.assets

  write: (readTree, destDir) ->
    readTree(this.inputTree).then (srcDir) =>
      @html = @listToGlobList @html
      @assets = @listToGlobList @assets
      return super readTree, destDir


  listToGlobList: (inputList) ->
    destDir = @inputTree.tmpDestDir

    result = []
    inputList.forEach (pattern) ->
      glob.sync(path.join(destDir, pattern)).forEach (file) ->
        relPath = path.relative(destDir, file)
        result.push relPath

    result

  readFromTree: (filePath) ->
    fs.readFileSync path.join(@inputTree.tmpDestDir, filePath)

  htmlPathToRelPath: (htmlDir, htmlPath) ->
    if htmlPath.indexOf '/' == 0
      htmlPath.slice 1
    else
      if htmlDir != '.'
        path.relative '.', path.resolve(htmlDir, htmlPath)
      else
        htmlPath

  processString: (string, htmlPath) ->
    htmlDir = path.dirname htmlPath

    if htmlPath in @html
      $ = cheerio.load string
      filter = @

      replaceEls = (selector, getSrc, createEl) ->
        $(selector).each ->
          $el = $ @
          srcFile = getSrc $el
          if filter.htmlPathToRelPath(htmlDir, srcFile) in filter.assets
            src = filter.readFromTree srcFile
            $newEl = createEl src
            $el.before $newEl
            $el.remove()

      replaceEls 'script[src]',
        ($script) -> $script.attr 'src',
        (src) -> $ """<script type="text/javascript">#{src}</script>"""

      replaceEls 'link[rel=stylesheet]',
        ($style) -> $style.attr 'href',
        (src) -> $ """<style type="text/css">#{src}</style>"""

      return $.html();

    return string

module.exports = (inputTree, options)->
  new InlineAssets inputTree, options
