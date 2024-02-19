import requests
import pandas as pd
import smtplib
import json
import time
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def get_crypto_price(crypto):
    url = f"https://api.coingecko.com/api/v3/simple/price?ids={crypto}&vs_currencies=usd"
    response = requests.get(url)
    data = response.json()
    return data[crypto]['usd']

def send_email(subject, message, email_config):
    # Setup the email parameters
    my_email = email_config['my_email']
    password = email_config['password']
    to_email = email_config['to_email']

    # Setup the email content
    msg = MIMEMultipart()
    msg['From'] = my_email
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(message, 'plain'))

    # Send the email
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(my_email, password)
    text = msg.as_string()
    server.sendmail(my_email, to_email, text)
    server.quit()

# Load the email configuration and crypto settings from a JSON file
with open('config.json') as f:
    config = json.load(f)

email_config = config['email']
cryptos = config['cryptos']
threshold = config['threshold']

while True:
    prices = {crypto: get_crypto_price(crypto) for crypto in cryptos}

    df = pd.DataFrame(prices, index=[0])

    # Check if the price has increased or decreased by the threshold
    for crypto, price in prices.items():
        change = df[crypto].pct_change()[-1]
        if change >= threshold:
            send_email(f"Price Alert: {crypto}", f"The price of {crypto} has increased by {threshold*100}% today.", email_config)
        elif change <= -threshold:
            send_email(f"Price Alert: {crypto}", f"The price of {crypto} has decreased by {threshold*100}% today.", email_config)

    # Save the data for future analysis
    df.to_csv('crypto_prices.csv', mode='a', header=False)

    # Wait for an hour before the next iteration
    time.sleep(30)
