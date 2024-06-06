#!/usr/bin/bash

set -euxo pipefail

declare -a names

for vendor in nvidia intel marvell
do
    names+=("${vendor^^}_BOOT_IMG_HASH_VAL" "${vendor^^}_CONFIG_B64")
    export ${vendor^^}_BOOT_IMG_HASH_VAL=$(openssl dgst -sha256 -c  ${vendor,,}-boot-image.img | awk '{print $2}')
    export ${vendor^^}_CONFIG_B64=$(openssl enc -base64 -A -in      ${vendor,,}-configuration.xml)
    for item in pre post
    do
        names+=("${vendor^^}_PRE_SCRIPT_B64" "${vendor^^}_POST_SCRIPT_B64")
        export ${vendor^^}_${item^^}_SCRIPT_B64=$(openssl enc -base64 -A -in  ${vendor,,}-${item,,}-configuration-script.sh)
    done
done

names+=(SBI_PRI_KEY_B64 SBI_PUB_KEY_B64 SBI_EE_CERT_B64 CLIENT_CERT_TA_B64)
export SBI_PRI_KEY_B64=$(openssl enc -base64 -A -in         private_key.der)
export SBI_PUB_KEY_B64=$(openssl enc -base64 -A -in         public_key.der)
export SBI_EE_CERT_B64=$(openssl enc -base64 -A -in         cert_chain.cms)
export CLIENT_CERT_TA_B64=$(openssl enc -base64 -A -in      ta_cert_chain.cms)

names+=(SZTPD_INIT_ADDR SZTPD_INIT_PORT SZTPD_NBI_PORT SZTPD_SBI_PORT)
export SZTPD_INIT_ADDR=$(awk '/SZTPD_INIT_ADDR:/{print $2}' ../docker-compose.yml)
export SZTPD_INIT_PORT=$(awk '/SZTPD_INIT_PORT:/{print $2}' ../docker-compose.yml)
export SZTPD_NBI_PORT=$(awk '/SZTPD_NBI_PORT:/{print $2}' ../docker-compose.yml)
export SZTPD_SBI_PORT=$(awk '/SZTPD_SBI_PORT:/{print $2}' ../docker-compose.yml)

envsubst "$(printf '${%s} ' ${names[@]})" < template.json > config.json

diff template.json config.json
