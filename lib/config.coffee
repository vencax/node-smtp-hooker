fs = require('fs')

CFGFILE = process.env.CFGFILE || __dirname + '/../config.json'

module.exports = config = JSON.parse(fs.readFileSync(CFGFILE))
