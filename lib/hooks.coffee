SMTPConnection = require('smtp-connection')
MailParser = require('mailparser').MailParser
request = require('request')

OUT_SMTP_HOST = process.env.OUT_SMTP_HOST or 'localhost'
OUT_SMTP_PORT = process.env.OUT_SMTP_PORT or 25

# This hook redirect a mail to given forward_dest
module.exports.forward = (connection, forward_dest, done) ->
  console.log 'forwarding to ' + forward_dest

  connection.client = new SMTPConnection
    port: OUT_SMTP_PORT
    host: OUT_SMTP_HOST
  connection.client.connect () ->
    # Client is ready to take message content, run done handler
    done()

  'open': () ->
    # nothing
    connection.data = ''
    return
  'write': (data) ->
    connection.data += data
  'end': () ->
    # Client is ready to init message
    connection.client.send
      from: connection.from
      to: [ forward_dest ]
    , connection.data, (err, info) ->
      return console.log err if err
      connection.client.quit()


# This hook post parsed mail's content as form to given url
module.exports.post2url = (connection, url, done) ->
  console.log 'posting to ' + url
  done()

  'open': ->
    connection.parser = new MailParser
    connection.parser.on 'end', (mail_object) ->
      _putData url, mail_object
  'write': (data) ->
    connection.parser.write data
  'end': ->
    connection.parser.end()

_putData = (url, data) ->
  opts =
    url: url
    form:
      'from': data.from or ''
      'subject': data.subject or ''
      'text': data.text or ''
    timeout: 1000
  data.attachments.map (a) ->
    opts.form[a.contentId] = a.content

  request.post opts, (err, httpResponse, body) ->
    return console.error('upload failed:', err) if err

    console.log 'Upload successful!  Server responded with:', body
  .on 'error', (err) ->
    console.error 'upload failed:', err
