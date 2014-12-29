module.exports = class HelenMysticCounter

  constructor: (@elID, @end) ->
    @startup()


  startup: ->
    (run = => @up())()
    @intvl = setInterval run, 37


  stopup: -> clearInterval @intvl


  up: -> document.getElementById(@elID).innerHTML = @str()


  str: ->

    timeDifference = @int @end

    if timeDifference > 0
      @format timeDifference
    else
      @stopup()
      '0.000'


  int: (date) ->

    defaultOffset = 480

    currentDate = new Date()
    currentTime = currentDate.getTime()
    currentOffset = currentDate.getTimezoneOffset()

    offsetDiff = defaultOffset - currentOffset
    timeDiff = offsetDiff * 60 * 1000

    futureTime = date.getTime()

    futureTime - currentTime + timeDiff


  format: (time) ->

    diffString = (time / 1000).toString()
    diffStringParts = diffString.split '.'

    if not diffStringParts[1]? then diffStringParts[1] = '000'
    while diffStringParts[1]?.length < 3
      diffStringParts[1] += '0'

    diffStringParts.join '.'
