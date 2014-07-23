# node-smtp-hooker

SMTP server for incomming mails.
According recipient address it runs a hook:

- REDIR hook - it resend the mail into another address. Useful if you have no mail hosting and want to receive mails on your domain.
- POST hook - it parses the mail and create HTML POST request with parsed content

## configuration

Done with JSON config file. Sample config file:
'''
{
    "node.ee": {
        "info": "vencax77@gmail.com",
        "credit": "http://localhost:5004/credithandler"
    },
    "neti.ee": {
        "credit": "http://neti.ee/credithandler"
    }
}
'''
Filename configurable through CFGFILE environment variable or defaults to config.json.

If you want to give a feedback, please [raise an issue](https://github.com/vencax/node-smtp-hooker/issues).
