module.exports = (number, trailingZeroes = 3) ->

  diffString = (number / 1000).toString()
  diffStringParts = diffString.split '.'

  if not diffStringParts[1]? then diffStringParts[1] = ''
  while diffStringParts[1]?.length < trailingZeroes
    diffStringParts[1] += '0'

  diffStringParts.join '.'
