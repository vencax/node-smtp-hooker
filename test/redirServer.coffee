
express = require('express')

module.exports = (g)->
  app = express()
  app.use(require('cors')({maxAge: 86400}))
  app.use(require('body-parser').json())

  app.use (req, res) ->
    g.redirbody = req.body
    res.json('ok')
