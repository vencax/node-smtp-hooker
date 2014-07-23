var fs = require('fs');

var CFGFILE = process.env.CFGFILE || 'config.json';

var config = JSON.parse(fs.readFileSync(CFGFILE));

module.exports = config;