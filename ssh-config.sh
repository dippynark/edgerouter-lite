#!/bin/bash

set -euo pipefail

sed -i 's/SSHD_OPTS=.*/SSHD_OPTS="-p 22 -o Protocol=2 -o ListenAddress=192.168.1.1"/' /etc/default/ssh
systemctl reload ssh
