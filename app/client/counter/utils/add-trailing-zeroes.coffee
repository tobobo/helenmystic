module.exports = (number, trailingZeroes = 3) ->

  numString = number.toString()
  numStringParts = numString.split '.'

  if not numStringParts[1]? then numStringParts[1] = ''
  while numStringParts[1]?.length < trailingZeroes
    numStringParts[1] += '0'

  numStringParts.join '.'
