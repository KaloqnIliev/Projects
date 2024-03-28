FROM python:3.7

WORKDIR /app

COPY . /app

RUN pip install flask flask_mysqldb

EXPOSE 5000

CMD ["python", "app.py"]
