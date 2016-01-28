from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEImage import MIMEImage
import smtplib
import os

msg = MIMEMultipart()
msg.attach(MIMEText(file("/home/vencax/teamviewer.txt").read()))
msg.attach(MIMEImage(file("logo.png").read()))

from_ = 'vencax@vxk.cz'
to = ['info@node.ee', 'credit@node.ee']

# to send
mailer = smtplib.SMTP()
mailer.connect('localhost', os.environ['TEST_SMTP_PORT'])
mailer.sendmail(from_, to, msg.as_string())
mailer.close()
