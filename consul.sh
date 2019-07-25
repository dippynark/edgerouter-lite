#!/bin/bash

set -e
set -x

# Add consul user
id -u consul || useradd -U consul

# Create hierachy
mkdir -p /etc/consul
mkdir -p /var/lib/consul

# Set permissions
chown consul:consul /etc/consul
chown consul:consul /var/lib/consul
chown consul:consul /config/scripts/post-config.d/consul.d/etc/consul/config.json

# Link config files
ln -snf /config/scripts/post-config.d/consul.d/etc/consul/config.json /etc/consul/config.json
ln -snf /config/scripts/post-config.d/consul.d/etc/consul/init.sh /etc/consul/init.sh
ln -snf /config/scripts/post-config.d/consul.d/etc/systemd/system/consul.service /etc/systemd/system/consul.service
ln -snf /config/scripts/post-config.d/consul.d/etc/systemd/system/consul-init.service /etc/systemd/system/consul-init.service
ln -snf /config/scripts/post-config.d/consul.d/etc/systemd/system/consul-init.timer /etc/systemd/system/consul-init.timer

# Link binary
ln -snf /config/scripts/post-config.d/consul.d/consul /usr/bin/consul

# Enable services
systemctl daemon-reload
systemctl enable consul consul-init consul-init.timer

# Reload services
systemctl start consul consul-init consul-init.timer
systemctl restart consul-init
