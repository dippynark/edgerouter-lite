#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

MATCHBOX_CONFIG_DIR=/etc/matchbox
VAULT_CONFIG_DIR=/etc/vault
export VAULT_ADDR=http://127.0.0.1:8200

# wait for matchbox server issue token
while true; do
    if [ -f "${VAULT_CONFIG_DIR}/matchbox-server-issue-token" ]; then
        echo "matchbox server issue token found"
        break
    fi
    echo "waiting for matchbox server issue token: ${VAULT_CONFIG_DIR}/matchbox-server-issue-token"
    sleep 1
done
export VAULT_TOKEN=$(cat "${VAULT_CONFIG_DIR}/matchbox-server-issue-token")

# renew matchbox server issue token
vault token renew > /dev/null
echo "matchbox server issue token renewed"

# generate server certificate
VAULT_RESPONSE=$(/usr/bin/vault write pki/matchbox/issue/server common_name=matchbox alt_names=matchbox.lukeaddison.co.uk -format=json)
umask 0077
echo ${VAULT_RESPONSE} | jq -r .data.private_key > "${MATCHBOX_CONFIG_DIR}/server.key"
echo ${VAULT_RESPONSE} | jq -r .data.certificate > "${MATCHBOX_CONFIG_DIR}/server.crt"
echo ${VAULT_RESPONSE} | jq -r .data.issuing_ca > "${MATCHBOX_CONFIG_DIR}/ca.crt"
chown matchbox:matchbox "${MATCHBOX_CONFIG_DIR}/server.key"
chown matchbox:matchbox "${MATCHBOX_CONFIG_DIR}/server.crt"
chown matchbox:matchbox "${MATCHBOX_CONFIG_DIR}/ca.crt"

echo "server certificate generated"

# restart matchbox
/bin/systemctl restart matchbox
