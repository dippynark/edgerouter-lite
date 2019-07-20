#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

set -x 

VAULT_CONFIG_DIR=/etc/vault
export VAULT_ADDR=http://127.0.0.1:8200

# initialise
while true; do
    VAULT_STATUS_CODE=$(curl -k -o /dev/null -w "%{http_code}" "${VAULT_ADDR}/v1/sys/health" || true)
    if [ "${VAULT_STATUS_CODE}" == "200" ] || [ "${VAULT_STATUS_CODE}" == "429" ] || [ "${VAULT_STATUS_CODE}" == "503" ]; then
        echo "initialised"
        break
    elif [ "${VAULT_STATUS_CODE}" == "501" ]; then
        echo "waiting for initialisation"
        sleep 1
        continue
        #VAULT_INIT_RESPONSE=$(curl -k --data '{"secret_shares":1,"secret_threshold":1}' "${VAULT_ADDR}/v1/sys/init")
        #VAULT_ROOT_TOKEN=$(echo "${VAULT_INIT_RESPONSE}" | jq -r .root_token)
        #VAULT_KEYS=$(echo "${VAULT_INIT_RESPONSE}" | jq -r .keys)
        #break
    fi

    echo "status code ${VAULT_STATUS_CODE} unknown, retrying"
    sleep 1
done

# wait for unseal key
while true; do
    if [ -f "${VAULT_CONFIG_DIR}/unseal-key" ]; then
        echo "unseal key found "
        break
    fi
    echo "waiting for unseal key: ${VAULT_CONFIG_DIR}/unseal-key"
    sleep 1
done
export VAULT_UNSEAL_KEY=$(cat "${VAULT_CONFIG_DIR}/unseal-key")

# unseal
while true; do
    VAULT_STATUS_CODE=$(curl -k -o /dev/null -w "%{http_code}" "${VAULT_ADDR}/v1/sys/health" || true)
    if [ "${VAULT_STATUS_CODE}" == "200" ] || [ "${VAULT_STATUS_CODE}" == "429" ]; then
        echo "unsealed"
        break
    elif [ "${VAULT_STATUS_CODE}" == "503" ]; then
        echo "waiting for unsealing"

        VAULT_UNSEAL_RESPONSE=$(curl -X PUT --data "{\"key\": \"${VAULT_UNSEAL_KEY}\"}" "${VAULT_ADDR}/v1/sys/unseal")
        continue
    fi

    echo "status code ${VAULT_STATUS_CODE} unknown, retrying"
    sleep 1    
done

# wait for root token
while true; do
    if [ -f "${VAULT_CONFIG_DIR}/root-token" ]; then
        echo "root token found "
        break
    fi
    echo "waiting for root token: ${VAULT_CONFIG_DIR}/root-token"
    sleep 1
done
export VAULT_TOKEN=$(cat "${VAULT_CONFIG_DIR}/root-token")

# generate server certificate
RESTART="false"
if [ ! -f "${VAULT_CONFIG_DIR}/server.crt" ] || [ ! -f "${VAULT_CONFIG_DIR}/server.key" ] || [ ! -f "${VAULT_CONFIG_DIR}/ca.crt" ]; then
    RESTART="true"
fi
VAULT_RESPONSE=$(/usr/bin/vault write pki/vault/issue/server common_name=vault alt_names=vault.lukeaddison.co.uk -format=json)
umask 0077
echo ${VAULT_RESPONSE} | jq -r .data.private_key > "${VAULT_CONFIG_DIR}/server.key"
echo ${VAULT_RESPONSE} | jq -r .data.certificate > "${VAULT_CONFIG_DIR}/server.crt"
echo ${VAULT_RESPONSE} | jq -r .data.issuing_ca > "${VAULT_CONFIG_DIR}/ca.crt"
chown vault:vault "${VAULT_CONFIG_DIR}/server.key"
chown vault:vault "${VAULT_CONFIG_DIR}/server.crt"
chown vault:vault "${VAULT_CONFIG_DIR}/ca.crt"

echo "server certificate generated"

if [ "${RESTART}" = "true" ]; then
    /bin/systemctl restart vault
    exit 1
fi

# reload vault
/bin/systemctl reload vault
