#!/bin/bash

# Add matchbox user
useradd -U matchbox

# Create directory structure
mkdir -p /var/lib/matchbox

# Link assets
ln -snf /config/scripts/post-config.d/matchbox.d/assets /var/lib/matchbox/assets
chown -R matchbox:matchbox /var/lib/matchbox

# Link config files
ln -snf /config/scripts/post-config.d/matchbox.d/etc/matchbox /etc/matchbox
ln -sf /config/scripts/post-config.d/matchbox.d/etc/init.d/matchbox /etc/init.d/matchbox

# Link binary
ln -sf /config/scripts/post-config.d/matchbox.d/matchbox /usr/local/bin/matchbox

# Enable service
update-rc.d matchbox defaults
update-rc.d matchbox enable

# Restart matchbox service
service matchbox restart
