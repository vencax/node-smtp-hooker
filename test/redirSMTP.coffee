
SMTPServer = require('smtp-server').SMTPServer

module.exports = (g)->

  smtp = new SMTPServer
    disabledCommands: ['AUTH']
    logger: process.env.DEBUG_SMTP_LOGGING || false

    onConnect: (session, callback) ->
      callback()

    onMailFrom: (address, session, callback) ->
      callback()

    onRcptTo: (address, session, callback) ->
      callback()

    onData: (stream, session, callback) ->
      g.incomingMails.push session
      session.data = ""
      stream.on 'data', (data)->
        session.data += data
      stream.on 'end', callback

  return smtp
