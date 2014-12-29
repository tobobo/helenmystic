HelenMysticCounter = require './helen-mystic-counter'

config = require '../config'

require('../analytics') config

helenMystic = new HelenMysticCounter 'mystic',
  new Date(config.endDate),
  config.defaultTimeZone
