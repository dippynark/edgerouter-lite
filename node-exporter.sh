#!/bin/bash

set -e
set -x

VERSION=0.18.1

# Install binary
mkdir -p /usr/bin/node-exporter
curl -SL https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-mips64.tar.gz > node_exporter.tar.gz
tar -xvf node_exporter.tar.gz -C /usr/bin/node-exporter/ --strip-components=1
rm node_exporter.tar.gz

# Link config files
ln -snf /config/scripts/post-config.d/node-exporter.d/etc/systemd/system/node-exporter.service /etc/systemd/system/node-exporter.service

# Enable service
systemctl daemon-reload
systemctl enable node-exporter.service

# Restart service
systemctl restart node-exporter.service
