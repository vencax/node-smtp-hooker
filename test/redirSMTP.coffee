
simplesmtp = require('simplesmtp')

module.exports = (g)->

  smtp = simplesmtp.createServer()

  # Set up recipient validation function
  smtp.on 'validateRecipient', (connection, email, done) ->
    console.log "RECEIVING: #{email}"
    done()

  smtp.on 'validateSender', (connection, email, done) ->
    console.log "TO: #{email}"
    done()

  smtp.on 'data', (connection, chunk) ->
    console.log chunk

  smtp.on 'dataReady', (connection, done) ->
    done()

  return smtp
