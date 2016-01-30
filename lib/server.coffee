SMTPServer = require('smtp-server').SMTPServer
winston = require('winston')
async = require('async')
config = require('./config')
handlers = require('./hooks')


module.exports = smtp = new SMTPServer
  disabledCommands: ['AUTH']
  # disableDNSValidation: true

  onMailFrom: (address, session, callback) ->
    # performed only once, so init the hooks
    session.hooks = []
    callback()

  onRcptTo: (address, session, callback) ->
    parts = (address.address or '').split('@')
    domain = parts[1].toLowerCase().trim()
    user = parts[0].toLowerCase().trim()
    if domain of config
      hooks = config[domain]
      if user of hooks
        session.hooks.push(hooks[user])
        callback()
      else
        return callback(new Error('Invalid user'))
    else
      callback(new Error('Invalid domain'))

  onData: (stream, session, callback) ->
    async.map session.hooks, (i, cb) ->
      if i.indexOf('@') > 0
        handlers.forward(i, stream, session, cb)
      else
        handlers.post2url(i, stream, session, cb)
    , (err, allresults) ->
      return callback(new Error(err)) if err
      callback()


smtp.on 'error', (err) ->
  winston.error('MainError: %s', err.message)
