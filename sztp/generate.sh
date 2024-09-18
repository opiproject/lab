#!/usr/bin/bash
# shellcheck disable=SC2034

set -euo pipefail

declare -a names

# files and configs
for vendor in nvidia intel marvell amd
do
    names+=("${vendor^^}_BOOT_IMG_HASH_VAL" "${vendor^^}_CONFIG_B64")
    export ${vendor^^}_BOOT_IMG_HASH_VAL="$(openssl dgst -sha256 -c  ./images/${vendor,,}-boot-image.img | awk '{print $2}')"
    export ${vendor^^}_CONFIG_B64="$(openssl enc -base64 -A -in      ./config/${vendor,,}-configuration.xml)"
    for item in pre post
    do
        names+=("${vendor^^}_${item^^}_SCRIPT_B64")
        export ${vendor^^}_${item^^}_SCRIPT_B64="$(openssl enc -base64 -A -in  ./config/${vendor,,}-${item,,}-configuration-script.sh)"
    done
done

# keys and sertificates
names+=(SBI_PRI_KEY_B64 SBI_PUB_KEY_B64 SBI_EE_CERT_B64 CLIENT_CERT_TA_B64)
SBI_PRI_KEY_B64=$(openssl enc -base64 -A -in    ./generated-server/private_key.der)
SBI_PUB_KEY_B64=$(openssl enc -base64 -A -in    ./generated-server/public_key.der)
SBI_EE_CERT_B64=$(openssl enc -base64 -A -in    ./generated-server/cert_chain.cms)
CLIENT_CERT_TA_B64=$(openssl enc -base64 -A -in ./generated-server/ta_cert_chain.cms)

# ports and addresses
names+=(SZTPD_INIT_ADDR SZTPD_INIT_PORT SZTPD_NBI_PORT SZTPD_SBI_PORT)
SZTPD_INIT_ADDR=$(awk '/SZTPD_INIT_ADDR:/{print $2}' ../docker-compose.yml)
SZTPD_INIT_PORT=$(awk '/SZTPD_INIT_PORT:/{print $2}' ../docker-compose.yml)
SZTPD_NBI_PORT=$(awk '/SZTPD_NBI_PORT:/{print $2}' ../docker-compose.yml)
SZTPD_SBI_PORT=$(awk '/SZTPD_SBI_PORT:/{print $2}' ../docker-compose.yml)

# generate template
export "${names[@]}"
# shellcheck disable=SC2016
envsubst "$(printf '${%s} ' "${names[@]}")" < template.json > generated_config.json

# check what changed
diff template.json generated_config.json || true

# client
echo ==================================
echo "Now COPY client files to the remote clients:"
echo scp ./generated-client/opi*.pem root@172.22.3.2:/mnt/
echo curl -X POST --data @/tmp/input.json -H "Content-Type:application/yang-data+json" --user nvidia-serial-number:my-secret --key /mnt/opi_private_key.pem --cert /mnt/opi_cert.pem --cacert /mnt/opi.pem https://bootstrap:8080/restconf/operations/ietf-sztp-bootstrap-server:get-bootstrapping-data
echo curl -X GET --key /mnt/opi_private_key.pem --cert /mnt/opi_cert.pem --cacert /mnt/opi.pem --output /tmp/nvidia-boot-image.img https://web:443/nvidia-boot-image.img
echo ==================================

# server
echo ==================================
echo "Now CONFIG server:"
echo curl --fail -i -X GET --user my-admin@example.com:my-secret -H 'Accept:application/yang-data+json' "http://127.0.0.1:${SZTPD_INIT_PORT}/restconf/ds/ietf-datastores:running"
echo curl --fail -i -X PUT --user my-admin@example.com:my-secret --data @./generated_config.json -H 'Content-Type:application/yang-data+json' "http://127.0.0.1:${SZTPD_INIT_PORT}/restconf/ds/ietf-datastores:running"
echo curl --fail -i -X GET --user my-admin@example.com:my-secret -H 'Accept:application/yang-data+json' "http://127.0.0.1:${SZTPD_NBI_PORT}/restconf/ds/ietf-datastores:running"
echo curl --fail -i -X GET --user my-admin@example.com:my-secret  -H "Accept:application/yang-data+json" "http://127.0.0.1:${SZTPD_NBI_PORT}/restconf/ds/ietf-datastores:operational/wn-sztpd-1:devices/device=nvidia-serial-number/bootstrapping-log"
echo curl --fail -H Accept:application/yang-data+json "http://127.0.0.1:${SZTPD_NBI_PORT}/.well-known/host-meta"
echo ==================================
