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
    @files = @options.files


  write: (readTree, destDir) ->

    readTree(this.inputTree).then (srcDir) =>

      for file, assets of @files
        globbedAssets = @listToGlobList srcDir, assets
        @listToGlobList srcDir, [file]
        .forEach (path) =>
          @files[path] = globbedAssets

      return super readTree, destDir


  canProcessFile: (relativePath) ->

    super(relativePath) and @files[relativePath]?


  processString: (string, filePath) ->

    replacer = @createReplacer string, filePath

    replacer.replace 'script[src]',
      ($script) -> $script.attr 'src',
      (source) -> """<script type="text/javascript">#{source}</script>"""

    replacer.replace 'link[rel=stylesheet]',
      ($style) -> $style.attr 'href',
      (source) -> """<style type="text/css">#{source}</style>"""

    replacer.html()


  listToGlobList: (rootDir, inputList) ->

    inputList.reduce (memo, pattern) ->
      glob.sync path.join(rootDir, pattern)
      .reduce (memo, file) ->
        memo.push path.relative(rootDir, file)
        memo
      , memo
    , []


  readFromTree: (filePath) ->

    fs.readFileSync path.join(@inputTree.tmpDestDir, filePath)


  createReplacer: (string, filePath) ->

    $: cheerio.load string

    htmlDir: path.dirname filePath

    filePath: filePath

    filter: @

    htmlPathToRelPath: (htmlPath) ->
      if htmlPath[0] == '/'
        htmlPath[1..]
      else
        if @htmlDir == '.'
          htmlPath
        else
          path.relative '.', path.resolve(@htmlDir, htmlPath)

    replace: (selector, getSourceFile, newEl) ->
      @$(selector).each (key, element) =>
        $el = @$ element
        sourceFile = @htmlPathToRelPath getSourceFile($el)
        if sourceFile in @filter.files[@filePath]
          src = @filter.readFromTree sourceFile
          $el.before(@$(newEl(src))).remove()

    html: -> @$.html()


module.exports = (inputTree, options)->
  new InlineAssets inputTree, options
