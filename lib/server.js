"use strict";

var simplesmtp = require("simplesmtp");
var config = require("./config");
var handlers = require("./hooks");

var smtp = simplesmtp.createServer();//{disableDNSValidation: true});

// Set up recipient validation function
smtp.on("validateRecipient", function(connection, email, done) {
    var parts = (email || "").split("@");
    var domain = parts[1].toLowerCase().trim();
    var user = parts[0].toLowerCase().trim();

    if(domain in config) {
        var hooks = config[domain];
        if(user in hooks) {
            if(hooks[user].indexOf("@") > 0) {
                connection.hooks.push(handlers.forward(connection, hooks[user], done));
            } else {
                connection.hooks.push(handlers.post2url(connection, hooks[user], done));
            }
        } else {
            return done(new Error("Invalid user"));
        }
    } else {
        done(new Error("Invalid domain"));
    }
});

smtp.on("validateSender", function(connection, email, done) {
    // performed only once, so init the hooks
    connection.hooks = [];
    done();
});

smtp.on("startData", function(connection){
    for(var i=0; i<connection.hooks.length; i++) {
        connection.hooks[i].open();
    }
});

smtp.on("data", function(connection, chunk){
    for(var i=0; i<connection.hooks.length; i++) {
        connection.hooks[i].write(chunk);
    }
});

smtp.on("dataReady", function(connection, done){
    for(var i=0; i<connection.hooks.length; i++) {
        connection.hooks[i].end();
    }
    done();
});

module.exports = smtp;
