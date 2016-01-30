# node-smtp-hooker

[![build status](https://api.travis-ci.org/vencax/node-smtp-hooker.svg)](https://travis-ci.org/vencax/node-smtp-hooker)


SMTP server for incomming mails.
According recipient address it runs a hook:

- REDIR hook - it resend the mail into another address.
    Useful if you have no mail hosting and want to receive mails on your (naked) domain.
- POST hook - it parses the mail and create HTML POST request with parsed content.
    Simply it is a SMTP to HTTP convertor.

## installation

    npm install git://github.com/vencax/node-smtp-hooker.git -g
    chmod a+x $NODE_PATH/node-smtp-hooker/misc/initscript.sh
    ln -s $NODE_PATH/node-smtp-hooker/misc/initscript.sh /etc/init.d/node-smtp-hooker
    npm install forever -g

## configuration

Done with JSON config file. Sample config file:

    {
        "node.ee": {
            "info": "vencax77@gmail.com",
            "credit": "http://localhost:5004/credithandler"
        },
        "neti.ee": {
            "credit": "http://neti.ee/credithandler"
        }
    }

Filename configurable through CFGFILE environment variable or defaults to config.json.

By default it runs on 8025 but the port can be overriden by PORT env. var. as usual.
However running on nonproviledged ports is safer but needs port redirection 25 -> 8025 (FW script included).

Useful when run as service (init script included) with [forever](https://github.com/nodejitsu/forever).

If you want to give a feedback, please [raise an issue](https://github.com/vencax/node-smtp-hooker/issues).
