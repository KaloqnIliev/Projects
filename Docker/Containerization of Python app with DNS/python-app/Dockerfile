# Use Python 3.9 on Debian 10 as base image
FROM python:3.9-slim-buster

# Set /app as working directory
WORKDIR /app

# Copy requirements.txt to /app
COPY ./src/requirements.txt .

# Install packages from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY ./src/run.py .
COPY ./src/app ./app

# Expose port 5000
EXPOSE 5000

# Run gunicorn on port 5000
CMD ["gunicorn", "-b", "0.0.0.0:5000", "run:app"]