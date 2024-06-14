#!/bin/bash

# Node Exporter
NODE_EXPORTER_VERSION="1.7.0"  # Replace with the desired version
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

# Create a user for Node Exporter
sudo useradd --no-create-home --shell /bin/false node_exporter

# Set permissions
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create a directory for Node Exporter
sudo mkdir /etc/node_exporter

# Create a configuration file for Node Exporter
cat <<EOF | sudo tee /etc/node_exporter/node_exporter.yml
scrape_configs:
- job_name: 'node'
static_configs:
    - targets: ['localhost:9100']
EOF

# Create a service file for Node Exporter
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
--collector.logind
[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the Node Exporter service
sudo systemctl daemon-reload
sudo systemctl unmask node_exporter
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Clean up downloaded files
rm node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64
