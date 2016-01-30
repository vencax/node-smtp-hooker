
SMTPServer = require('smtp-server').SMTPServer

module.exports = (g)->

  smtp = new SMTPServer
    disabledCommands: ['AUTH']
    logger: true

    onConnect: (session, callback) ->
      callback()

    onMailFrom: (address, session, callback) ->
      callback()

    onRcptTo: (address, session, callback) ->
      callback()

    onData: (stream, session, callback) ->
      g.incomingMail = session
      stream.pipe(process.stdout)
      stream.on('end', callback)

  return smtp
