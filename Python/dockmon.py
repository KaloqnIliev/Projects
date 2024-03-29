import docker
import subprocess
import time
from datetime import datetime, timedelta

# Create a docker client
client = docker.from_env()

# Function to check if Docker daemon is running
def is_docker_running():
    try:
        client.ping()
        return True
    except:
        return False

# Function to restart Docker daemon
def restart_docker():
    subprocess.run(['systemctl', 'restart', 'docker'])

# Function to check if Docker Swarm is active
def is_swarm_active():
    info = client.info()
    return info.get('Swarm', {}).get('LocalNodeState') == 'active'

# Function to initialize Docker Swarm
def init_swarm():
    client.swarm.init(advertise_addr='ip')


# Function to start stopped containers that are not 1 minute old
def start_containers():
    # Get the current time
    now = datetime.now()

    # Get all containers
    containers = client.containers.list(all=True)

    for container in containers:
        # Get the status of the container
        status = container.status

        # Get the creation time of the container
        created_time = container.attrs['Created']

        # Convert the creation time to datetime object
        created_time = datetime.strptime(created_time.split('.')[0], "%Y-%m-%dT%H:%M:%S")

        # If the container is less than 1 minute old and not running
        if now - created_time < timedelta(minutes=1) and status != "running":
            print(f"Starting container {container.id}")
            container.start()

        # If the container is more than 1 minute old
        elif now - created_time > timedelta(minutes=1):
            print(f"Removing container {container.id}")
            container.remove(force=True)
            print(f"Removing image {container.image.tags[0]}")
            client.images.remove(container.image.tags[0])

# Continuously monitor Docker Swarm
while True:
    if not is_docker_running():
        restart_docker()
    if not is_swarm_active():
        init_swarm()
    start_containers()
    time.sleep(60)  # Check every minute
