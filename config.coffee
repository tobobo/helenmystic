module.exports = (env) ->
  env = env or process.env.NODE_ENV or 'development'
  port = process.env.PORT or 3000

  endDate = new Date()
  endDate.setFullYear 2015
  endDate.setMonth 0, 1
  endDate.setHours 12, 0, 0, 0

  gaKey = process.env.HELENMYSTIC_GOOGLE_ANALYTICS_KEY

  env: env
  port: port
  endDate: endDate
  gaKey: gaKey
  client:
    endDate: endDate
    gaKey: gaKey
    defaultTimeZone: 480
