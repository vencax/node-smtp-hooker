
var server = require('./lib/server');
var port = process.env.PORT || 8025;


server.listen(port, 'localhost', function(err) {
    if(err) {
        console.log(err);
    } else {
        console.log('listening on ' + port);
    }
});
