var smtp = require('simplesmtp');
var MailParser = require("mailparser").MailParser;
var request = require('request');

var OUT_SMTP_HOST = process.env.OUT_SMTP_HOST || 'localhost';
var OUT_SMTP_PORT = process.env.OUT_SMTP_PORT || 25;

// This hook redirect a mail to given forward_dest
module.exports.forward = function(connection, forward_dest, done) {
    console.log("forwarding to " + forward_dest);

    connection.client = smtp.connect(OUT_SMTP_PORT, OUT_SMTP_HOST);

    connection.client.once("idle", function() {
        // Client is ready to init message
        connection.client.useEnvelope({
            from: connection.from,
            to: [forward_dest]}
        );
    });

    connection.client.on("message", function() {
        // Client is ready to take message content, run done handler
        done();
    });

    return {
        'open': function() {
            // nothing
        },
        'write': function(data) {
            connection.client.write(data);
        },
        'end': function() {
            connection.client.end();
        }
    };
};

// This hook post parsed mail's content as form to given url
module.exports.post2url = function(connection, url, done) {
    console.log("posting to " + url);
    done();

    return {
        'open': function() {
            connection.parser = new MailParser();

            connection.parser.on("end", function(mail_object) {
                _putData(url, mail_object);
            });
        },
        'write': function(data) {
            connection.parser.write(data);
        },
        'end': function() {
            connection.parser.end();
        }
    };
};

var _putData = function(url, data) {
    var opts = {
        url: url,
        form: {
            'from': data.from || '',
            'subject': data.subject || '',
            'text': data.text || ''
        },
        timeout: 1000
    };
    data.attachments.map(function(a) {
        opts.form[a.contentId] = a.content;
    });

    request.post(opts, function(err, httpResponse, body) {
        if (err) {
            return console.error('upload failed:', err);
        }
        console.log('Upload successful!  Server responded with:', body);
    }).on('error', function(err) {
        console.error('upload failed:', err);
    });
};
