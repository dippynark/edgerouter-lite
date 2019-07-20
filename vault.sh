#!/bin/bash

set -e
set -x

# Add vault user
id -u vault || useradd -U vault

# Create hierachy
mkdir -p /etc/vault
mkdir -p /var/lib/vault

# Set permissions
chown vault:vault /etc/vault
chown vault:vault /var/lib/vault
chown vault:vault /config/scripts/post-config.d/vault.d/etc/vault/config.hcl
chown vault:vault /config/scripts/post-config.d/vault.d/etc/vault/bootstrap.hcl
chown vault:vault /config/scripts/post-config.d/vault.d/etc/vault/wrapper.sh

# Link config files
ln -snf /config/scripts/post-config.d/vault.d/etc/vault/config.hcl /etc/vault/config.hcl
ln -snf /config/scripts/post-config.d/vault.d/etc/vault/bootstrap.hcl /etc/vault/bootstrap.hcl
ln -snf /config/scripts/post-config.d/vault.d/etc/vault/wrapper.sh /etc/vault/wrapper.sh
ln -snf /config/scripts/post-config.d/vault.d/etc/vault/init.sh /etc/vault/init.sh
ln -snf /config/scripts/post-config.d/vault.d/etc/systemd/system/vault.service /etc/systemd/system/vault.service
ln -snf /config/scripts/post-config.d/vault.d/etc/systemd/system/vault-init.service /etc/systemd/system/vault-init.service
ln -snf /config/scripts/post-config.d/vault.d/etc/systemd/system/vault-init.timer /etc/systemd/system/vault-init.timer

# Link binary
ln -snf /config/scripts/post-config.d/vault.d/vault /usr/bin/vault

# Enable services
systemctl daemon-reload
systemctl enable vault vault-init vault-init.timer

# Reload services
systemctl start vault vault-init vault-init.timer
systemctl restart vault-init
