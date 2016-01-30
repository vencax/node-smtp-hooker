SMTPConnection = require('smtp-connection')
MailParser = require('mailparser').MailParser
request = require('request')
winston = require('winston')

OUT_SMTP_HOST = process.env.OUT_SMTP_HOST or 'localhost'
OUT_SMTP_PORT = process.env.OUT_SMTP_PORT or 25

# This hook redirect a mail to given forward_dest
exports.forward = (forward_dest, stream, session, cb) ->
  client = new SMTPConnection
    port: OUT_SMTP_PORT
    host: OUT_SMTP_HOST
    ignoreTLS: true
    connectionTimeout: 2000
    greetingTimeout: 2000
  client.on 'error', (err)->
    winston.error(err)
    cb(new Error(err))
  client.on 'end', () ->
    client.quit();

  client.connect () ->
    opts =
      from: session.envelope.mailFrom.address
      to: [ forward_dest ]
    client.send opts, stream, (err, stat)->
      cb(err) if err
      winston.info('forwarded to ' + forward_dest)
      cb()


# This hook post parsed mail's content as form to given url
module.exports.post2url = (url, stream, session, cb) ->
  parser = new MailParser
  stream.pipe(parser)

  parser.on 'end', (mail_object) ->
    request.post
      url: url
      json: true
      body:
        'from': session.envelope.mailFrom.address
        'to': session.envelope.rcptTo
        'subject': mail_object.subject or ''
        'text': mail_object.text or ''
        'atts': mail_object.attachments
      timeout: 1000
    , (err, httpResponse, body) ->
      return cb('upload failed:' + err) if err
      winston.info('posted to ' + url)
      cb(null, body)
