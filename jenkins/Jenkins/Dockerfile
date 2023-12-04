# Use the official SonarQube image as a base
FROM sonarqube:latest

# Expose the required ports
EXPOSE 9000

# Set the SONARQUBE_HOME environment variable
ENV SONARQUBE_HOME=/opt/sonarqube

# Set the Java options to allocate 3GB of RAM
ENV SONAR_WEB_JAVA_OPTS="-Xmx3g -Xms3g"