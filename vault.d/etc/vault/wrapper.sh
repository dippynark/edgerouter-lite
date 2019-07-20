#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

VAULT_CONFIG_DIR=/etc/vault

# TODO: check certs are valid 
if [ -f "${VAULT_CONFIG_DIR}/server.crt" ] && [ -f "${VAULT_CONFIG_DIR}/server.key" ] && [ -f "${VAULT_CONFIG_DIR}/ca.crt" ]; then
    exec /usr/bin/vault server -config /etc/vault/config.hcl
fi

exec /usr/bin/vault server -config /etc/vault/bootstrap.hcl
