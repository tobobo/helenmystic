module.exports = (date, offset = 0) ->
  currentDate = new Date()
  currentTime = currentDate.getTime()
  currentOffset = currentDate.getTimezoneOffset()

  offsetDiff = offset - currentOffset
  timeDiff = offsetDiff * 60 * 1000

  futureTime = date.getTime()

  futureTime - currentTime + timeDiff
