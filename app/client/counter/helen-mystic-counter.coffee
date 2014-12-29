timeToDate = require './time-to-date'
addTrailingZeroes = require './add-trailing-zeroes'

module.exports = class HelenMysticCounter

  constructor: (@elID, @end, @timeZoneOffset) ->
     @startup()


  up: ->
    @el().innerHTML = @str()

    if @tr <= 0
      @done()
      @stopup()


  startup: ->
    @updating = true
    (run = => @up())()
    @intvl = setInterval run, 37


  stopup: ->
    @updating = false
    clearInterval @intvl


  el: -> document.getElementById(@elID)


  swap: ->
    @el().style.color = 'white'
    window.document.body.style.backgroundColor = 'black'


  done: ->

    @swap()

    setTimeout ->
      window.location.reload()
    , 4000


  str: ->

    if not @updating then return

    timeRemaining = @int @end

    @trs = if timeRemaining > 0
      @format timeRemaining
    else
      '0.000'


  int: (date) -> @tr = timeToDate date, @timeZoneOffset


  format: (number) -> addTrailingZeroes number, 3
