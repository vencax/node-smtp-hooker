require('coffee-script/register');

var port = process.env.PORT || 8025;
var host = process.env.HOST || 'localhost';
var server = require('./lib/server');

server.listen(port, host, function(err) {
  if(err) {
      return console.log(err);
  }
  console.log('stalking britney spears on ' + host + ':' + port);
});
