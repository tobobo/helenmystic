module.exports = (grunt) ->
  config = require('../config')()

  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  coffeePath = 'node_modules/.bin/coffee'

  grunt.initConfig
    watch:
      server:
        files: [
          'app/**/*',
          'config.coffee'
          'index.coffee'
        ]
        tasks: 'express:development'
        options:
          spawn: false
          livereload: true

    express:
      development:
        options:
          node_env: 'development'
          port: config.port
          opts: [coffeePath]
          output: 'listening'
          script: 'index.coffee'

      production:
        options:
          node_env: 'production'
          port: config.port
          opts: [coffeePath]
          output: 'listening'
          script: 'index.coffee'
          background: false

  grunt.registerTask 'server', ['express:development', 'watch:server']
  grunt.registerTask 'server:development', ['server']
  grunt.registerTask 'server:production', ['express:production']
