getTimeToDate = (date) ->
  defaultOffset = 480

  currentDate = new Date()
  currentTime = currentDate.getTime()
  currentOffset = currentDate.getTimezoneOffset()

  offsetDiff = defaultOffset - currentOffset
  timeDiff = offsetDiff * 60 * 1000

  futureTime = date.getTime()

  futureTime - currentTime + timeDiff

updateDisplay = ->
  endDate = new Date()
  endDate.setFullYear 2015
  endDate.setMonth 0, 1
  endDate.setHours 12, 0, 0, 0

  timeDifference = getTimeToDate endDate
  timeDifference = 0

  if timeDifference > 0
    diffString = (timeDifference / 1000).toString()
    diffStringParts = diffString.split '.'

    while diffStringParts[1]?.length < 3
      diffStringParts[1] += '0'

    diffString = diffStringParts.join '.'
  else
    diffString = '0.000'

  document.getElementById('mystic').innerHTML = diffString

updateDisplay()
setInterval updateDisplay, 37
