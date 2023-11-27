# Use the official Docker Image of BIND 9 
FROM ubuntu/bind9:latest

# Install dependencies 
RUN apt-get update && apt-get install -y \
    bind9 \
    bind9utils \
    bind9-doc

# Copy the configuration files directly into the Docker image
COPY ./bind/named.conf.options .
COPY ./bind/named.conf.local .
COPY ./bind/zones/db.vrofile.shop .

# Expose port 53 for DNS 
EXPOSE 53/udp
EXPOSE 53/tcp
