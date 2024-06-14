import os
import json
import psutil
import smtplib
import time
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

# Load credentials from a json file
with open('/path/to/credentials.json', 'r') as file:
    credentials = json.load(file)

# Function to send email
def send_email(subject, body, filename=None):
    sender_address = credentials['email']
    sender_pass = credentials['password']
    receiver_address = 'receiver_email@example.com'
    message = MIMEMultipart()
    message['From'] = sender_address
    message['To'] = receiver_address
    message['Subject'] = subject
    message.attach(MIMEText(body, 'plain'))

    if filename:
        with open(filename, 'rb') as attachment:
            part = MIMEBase('application', 'octet-stream')
            part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename= ' + filename)
        message.attach(part)

    session = smtplib.SMTP('smtp.gmail.com', 587)
    session.starttls()
    session.login(sender_address, sender_pass)
    text = message.as_string()
    session.sendmail(sender_address, receiver_address, text)
    session.quit()

# Function to check system status
def check_system():
    try:
        cpu_usage = psutil.cpu_percent()
        memory_usage = psutil.virtual_memory().percent
        disk_usage = psutil.disk_usage('/').percent

        with open('system_usage.txt', 'a') as file:
            file.write(f'CPU Usage: {cpu_usage}%\n')
            file.write(f'Memory Usage: {memory_usage}%\n')
            file.write(f'Disk Usage: {disk_usage}%\n')
            file.write('---\n')

        if cpu_usage > 70 or memory_usage > 70 or disk_usage > 70:
            send_email('System Alert', 'One or more system resources are above 70% usage.', 'system_usage.txt')

    except Exception as e:
        print(f'Error occurred: {e}')
        send_email('System Down Alert', 'Your system is down!')

# Continuously monitor system
while True:
    check_system()
    time.sleep(60)  # Check every minute