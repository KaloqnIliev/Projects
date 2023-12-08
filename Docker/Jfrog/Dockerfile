# Use the official JFrog Artifactory OSS Docker image
FROM docker.bintray.io/jfrog/artifactory-oss:latest

# Environment variables
ENV ARTIFACTORY_HOME /var/opt/jfrog/artifactory

# Specify the user
USER root

# Expose the default Artifactory port
EXPOSE 8081

# Define a volume
VOLUME ~/Jfog/repo

# Start Artifactory
CMD ["./bin/artifactory.sh"]