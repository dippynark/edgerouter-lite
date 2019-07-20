#!/bin/bash

set -e
set -x

# Add matchbox user
id -u matchbox || useradd -U matchbox

# Create directory structure
mkdir -p /etc/matchbox
mkdir -p /var/lib/matchbox/assets

# Set permissions
chown matchbox:matchbox /etc/matchbox
chown matchbox:matchbox /var/lib/matchbox
chown matchbox:matchbox /var/lib/matchbox/assets

# Link config files
ln -snf /config/scripts/post-config.d/matchbox.d/etc/matchbox/init.sh /etc/matchbox/init.sh
ln -snf /config/scripts/post-config.d/matchbox.d/etc/systemd/system/matchbox.service /etc/systemd/system/matchbox.service
ln -snf /config/scripts/post-config.d/matchbox.d/etc/systemd/system/matchbox-init.service /etc/systemd/system/matchbox-init.service
ln -snf /config/scripts/post-config.d/matchbox.d/etc/systemd/system/matchbox-init.timer /etc/systemd/system/matchbox-init.timer

# Link binary
ln -sf /config/scripts/post-config.d/matchbox.d/matchbox /usr/bin/matchbox

# Enable services
systemctl daemon-reload
systemctl enable matchbox matchbox-init matchbox-init.timer

# Reload services
systemctl start matchbox matchbox-init matchbox-init.timer
systemctl restart matchbox-init
