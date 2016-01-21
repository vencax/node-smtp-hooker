simplesmtp = require('simplesmtp')
config = require('./config')
handlers = require('./hooks')

module.exports = smtp = simplesmtp.createServer()
  # disableDNSValidation: true

# Set up recipient validation function
smtp.on 'validateRecipient', (connection, email, done) ->
  parts = (email or '').split('@')
  domain = parts[1].toLowerCase().trim()
  user = parts[0].toLowerCase().trim()
  if domain of config
    hooks = config[domain]
    if user of hooks
      if hooks[user].indexOf('@') > 0
        connection.hooks.push handlers.forward(connection, hooks[user], done)
      else
        connection.hooks.push handlers.post2url(connection, hooks[user], done)
    else
      return done(new Error('Invalid user'))
  else
    done new Error('Invalid domain')

smtp.on 'validateSender', (connection, email, done) ->
  # performed only once, so init the hooks
  connection.hooks = []
  done()

smtp.on 'startData', (connection) ->
  for i in connection.hooks
    i.open()

smtp.on 'data', (connection, chunk) ->
  for i in connection.hooks
    i.write(chunk)

smtp.on 'dataReady', (connection, done) ->
  for i in connection.hooks
    i.end()
  done()
