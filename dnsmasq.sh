#!/bin/bash

set -e

# Link PXE config
ln -sf /config/scripts/post-config.d/dnsmasq.d/dnsmasq-pxe-config.conf /etc/dnsmasq.d/dnsmasq-pxe-config.conf

# Link iPXE copy to TFTP root
ln -snf /config/scripts/post-config.d/dnsmasq.d/tftpboot /var/lib/tftpboot

# Restart dnsmasq service
service dnsmasq restart
