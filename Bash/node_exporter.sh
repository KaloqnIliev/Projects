#!/bin/bash

# Update system
sudo apt-get update

# Install necessary packages
sudo apt-get install -y curl wget apt-transport-https software-properties-common

# Install Prometheus
PROMETHEUS_VERSION="2.48.0"  # Replace with the latest version
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus.yml /etc/prometheus/
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus /var/lib/prometheus
sudo cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles /etc/prometheus/
sudo cp -r prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Create Prometheus configuration
cat <<EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s  

scrape_configs:
  - job_name: 'node'
    scrape_interval: 5s  
    static_configs:
      - targets: ['localhost:9100']  
    metrics_path: /metrics
    params:
      format: [node_memory_MemTotal,node_memory_MemFree,node_cpu_seconds_total,node_filesystem_avail_bytes,node_filesystem_size_bytes]
  - job_name: 'prometheus'
    scrape_interval: 10s  
    static_configs:
      - targets: ['localhost:9090']
EOF

# Create Prometheus service
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Install Grafana
sudo apt-get update
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_10.2.2_amd64.deb
sudo dpkg -i grafana-enterprise_10.2.2_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Configure Grafana to work with Prometheus
cat <<EOF | sudo tee -a /etc/grafana/grafana.ini
[server]
protocol = http
http_port = 3000

[datasource]
type = prometheus
url = http://localhost:9090
access = proxy
EOF

# Restart Grafana
sudo systemctl restart grafana-server

# Clean up downloaded and extracted files
cd ~
sudo rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64*
sudo rm -f grafana-enterprise_10.2.2_amd64.deb