#!/usr/bin/env bash

VAULT_TOKEN="dbb4e807-fae2-4e6d-958f-f9b4ca27c36c"

function call_vault () {
    path=$1
    curl --header "X-Vault-Token: ${VAULT_TOKEN}" "http://${VAULT_IP}:8200${path}"
}

docker run \
    --rm \
    --cap-add=IPC_LOCK \
    --name=vault \
    --env=VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN} \
    --detach=true \
    vault

VAULT_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' vault)

echo "Using vault ip address: ${VAULT_IP}"

until $(curl --output /dev/null --silent --head --fail --header "X-Vault-Token: ${VAULT_TOKEN}" http://${VAULT_IP}:8200/v1/sys/health); do
    printf '.'
    sleep 5
done

echo "Vault is up!"
echo "Mounting pki"

curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @drb-kube-pki.json \
    "http://${VAULT_IP}:8200/v1/sys/mounts/drb-kube-pki"

echo "Creating CA"

root_ca_data=$(curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @ca.json \
    "http://${VAULT_IP}:8200/v1/drb-kube-pki/root/generate/internal")
echo ${root_ca_data} | jq -r '.data.certificate' > ca.crt

echo "Creating role."
curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @role.json \
    "http://${VAULT_IP}:8200/v1/drb-kube-pki/roles/drb-kube"

echo "Creating token cert."
token_crt_data=$(curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @token-crt.json \
    "http://${VAULT_IP}:8200/v1/drb-kube-pki/issue/drb-kube")
echo ${token_crt_data} | jq -r '.data.certificate' > token.crt
echo ${token_crt_data} | jq -r '.data.private_key' > token.key

echo "Creating api server cert."
api_server_crt_data=$(curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @api-server.json \
    "http://${VAULT_IP}:8200/v1/drb-kube-pki/issue/drb-kube")
echo ${api_server_crt_data} | jq -r '.data.certificate' > apiserver.crt
echo ${api_server_crt_data} | jq -r '.data.private_key' > apiserver.key

echo "Creating kubelet cert."
token_crt_data=$(curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @kubelet.json \
    "http://${VAULT_IP}:8200/v1/drb-kube-pki/issue/drb-kube")
echo ${token_crt_data} | jq -r '.data.certificate' > kubelet.crt
echo ${token_crt_data} | jq -r '.data.private_key' > kubelet.key

echo "Creating admin cert."
token_crt_data=$(curl \
    --header "X-Vault-Token: ${VAULT_TOKEN}" \
    --request POST \
    --data @admin.json \
    "http://${VAULT_IP}:8200/v1/drb-kube-pki/issue/drb-kube")
echo ${token_crt_data} | jq -r '.data.certificate' > admin.crt
echo ${token_crt_data} | jq -r '.data.private_key' > admin.key

echo "Stopping vault."
docker stop vault
