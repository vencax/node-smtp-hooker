
should = require('should')
http = require('http')
fs = require('fs')
horaa = require 'horaa'
mock = require('mock-require')
exec = require('child_process').exec

port = process.env.PORT || 3333
baseurl="http://localhost:#{port}"
process.env.NODE_ENV='devel'
process.env.CFGFILE=__dirname + '/testconfig.json'
process.env.OUT_SMTP_PORT = 25005

text = 'Ahoj,jak se mas, ja dobre: úůěščřžýáíé'

g =
  childEnv:
    cwd: __dirname
    env:
      TEST_SMTP_PORT: port
      TEST_SMTP_TEXT_MESSAGE: text

  checkStatus: (res, desiredStatus)->
    console.log res.body
    res.statusCode.should.eql desiredStatus
  port: port
  storagePORT: port + 1
  sentemails: []

sendMail = (mail, cb) ->
  g.sentemails.push mail
  cb()

# entry ...
describe "app", ->

  g.server = require(__dirname + '/../lib/server')

  before (done) ->

    g.server.listen port, (err) ->
      return done(err) if err

      g.redirServer = require('./redirServer')(g).listen 25004, (err) ->
        return done(err) if err

        rsport = process.env.OUT_SMTP_PORT
        g.redirSMTPServer = require('./redirSMTP')(g)
        g.redirSMTPServer.listen rsport, (err) ->
          return done(err) if err
          done()

  after (done) ->
    g.server.close()
    g.redirServer.close()
    g.redirSMTPServer.close()
    done()

  it "shall POST to url", (done) ->
    cmd = "python #{__dirname}/send.py"
    g.childEnv.env.TEST_SMTP_TO_ADDR = '["credit@node.ee"]'
    child = exec cmd, g.childEnv, (err, stdout, stderr) ->
      return done(err) if err
      g.redirbody.text.should.eql text
      g.redirbody.atts[0].contentType.should.eql 'image/png'
      done()

  it "shall forward", (done) ->
    cmd = "python #{__dirname}/send.py"
    g.childEnv.env.TEST_SMTP_TO_ADDR = '["info@node.ee"]'
    child = exec cmd, g.childEnv, (err, stdout, stderr) ->
      return done(err) if err
      console.log g.incomingMail
      done()
