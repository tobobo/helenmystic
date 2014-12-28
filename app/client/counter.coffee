require './analytics'

HelenMysticCounter = require './helen-mystic-counter'

janFirstNoon = new Date()
janFirstNoon.setFullYear 2015
janFirstNoon.setMonth 0, 1
janFirstNoon.setHours 12, 0, 0, 0

helenMystic = new HelenMysticCounter 'mystic', janFirstNoon
