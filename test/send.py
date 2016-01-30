from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage
import smtplib
import json
import os

msg = MIMEMultipart()
msg.attach(MIMEText(os.environ.get('TEST_SMTP_TEXT_MESSAGE', 'ahoj')))
msg.attach(MIMEImage(file("logo.png").read()))

from_ = 'vencax@vxk.cz'
to = json.loads(os.environ['TEST_SMTP_TO_ADDR'])

# to send
mailer = smtplib.SMTP()
mailer.connect('localhost', os.environ.get('TEST_SMTP_PORT', 8025))
mailer.sendmail(from_, to, msg.as_string())
mailer.close()
