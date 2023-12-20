# Use the official Sonatype Nexus Repository OSS Docker image
FROM sonatype/nexus3:latest

# Environment variables
ENV NEXUS_HOME /nexus-data

# Specify the user
USER root

# Expose the default Nexus port
EXPOSE 8081

# Define a volume
VOLUME ~/Nexus/repo

# Start Nexus
CMD ["./bin/nexus", "run"]
