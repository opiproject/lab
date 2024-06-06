#!/usr/bin/bash

set -euxo pipefail

MYTMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$MYTMPDIR"' EXIT

curl -kL https://watsen.net/support/sztpd-simulator-0.0.11.tgz | tar -zxvf - -C ${MYTMPDIR}/
pushd ${MYTMPDIR}/sztpd-simulator/pki
echo "DNS.2 = bootstrap" >> sztpd1/sbi/end-entity/openssl.cnf
echo "DNS.3 = web" >> sztpd1/sbi/end-entity/openssl.cnf
echo "DNS.4 = redirecter" >> sztpd1/sbi/end-entity/openssl.cnf
make pki
# SBI Port certificates
cat sztpd1/sbi/end-entity/my_cert.pem sztpd1/sbi/intermediate2/my_cert.pem > ${MYTMPDIR}/sztpd-simulator/cert_chain.pem
openssl crl2pkcs7 -nocrl -certfile ${MYTMPDIR}/sztpd-simulator/cert_chain.pem -outform DER -out ${MYTMPDIR}/sztpd-simulator/cert_chain.cms
# client cert DevID trust anchors
cat client/root-ca/my_cert.pem client/intermediate1/my_cert.pem client/intermediate2/my_cert.pem > ${MYTMPDIR}/sztpd-simulator/ta_cert_chain.pem
openssl crl2pkcs7 -nocrl -certfile ${MYTMPDIR}/sztpd-simulator/ta_cert_chain.pem -outform DER -out ${MYTMPDIR}/sztpd-simulator/ta_cert_chain.cms
# ???
cat sztpd1/sbi/root-ca/my_cert.pem sztpd1/sbi/intermediate1/my_cert.pem > ${MYTMPDIR}/sztpd-simulator/opi.pem
popd

# copy locally for server
rm -rf ./generated-server
mkdir -p ./generated-server
cp ${MYTMPDIR}/sztpd-simulator/pki/sztpd1/sbi/end-entity/private_key.der ./generated-server/
cp ${MYTMPDIR}/sztpd-simulator/pki/sztpd1/sbi/end-entity/public_key.der ./generated-server/
cp ${MYTMPDIR}/sztpd-simulator/cert_chain.cms ./generated-server/
cp ${MYTMPDIR}/sztpd-simulator/ta_cert_chain.cms ./generated-server/

# copy remotely for clients
rm -rf ./generated-client
mkdir -p ./generated-client
cp ${MYTMPDIR}/sztpd-simulator/opi.pem ./generated-client/opi.pem
cp ${MYTMPDIR}/sztpd-simulator/pki/client/end-entity/my_cert.pem ./generated-client/opi_cert.pem
cp ${MYTMPDIR}/sztpd-simulator/pki/client/end-entity/private_key.pem ./generated-client/opi_private_key.pem

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
export SBI_PRI_KEY_B64=$(openssl enc -base64 -A -in    ./generated-server/private_key.der)
export SBI_PUB_KEY_B64=$(openssl enc -base64 -A -in    ./generated-server/public_key.der)
export SBI_EE_CERT_B64=$(openssl enc -base64 -A -in    ./generated-server/cert_chain.cms)
export CLIENT_CERT_TA_B64=$(openssl enc -base64 -A -in ./generated-server/ta_cert_chain.cms)

names+=(SZTPD_INIT_ADDR SZTPD_INIT_PORT SZTPD_NBI_PORT SZTPD_SBI_PORT)
export SZTPD_INIT_ADDR=$(awk '/SZTPD_INIT_ADDR:/{print $2}' ../docker-compose.yml)
export SZTPD_INIT_PORT=$(awk '/SZTPD_INIT_PORT:/{print $2}' ../docker-compose.yml)
export SZTPD_NBI_PORT=$(awk '/SZTPD_NBI_PORT:/{print $2}' ../docker-compose.yml)
export SZTPD_SBI_PORT=$(awk '/SZTPD_SBI_PORT:/{print $2}' ../docker-compose.yml)

envsubst "$(printf '${%s} ' ${names[@]})" < template.json > config.json

diff template.json config.json || true

echo "Now COPY client files to the remote clients:"
echo scp ./generated-client/opi*.pem root@172.22.3.2:/mnt/

# curl --fail -H Accept:application/yang-data+json http://127.0.0.1:$SZTPD_NBI_PORT/.well-known/host-meta || exit 1
# curl --fail -i -X GET --user my-admin@example.com:my-secret -H 'Accept:application/yang-data+json' http://bootstrap:"${SZTPD_INIT_PORT}"/restconf/ds/ietf-datastores:running
# curl --fail -i -X PUT --user my-admin@example.com:my-secret --data @./config.json -H 'Content-Type:application/yang-data+json' http://127.0.0.1:"${SZTPD_INIT_PORT}"/restconf/ds/ietf-datastores:running
# curl --fail -i -X GET --user my-admin@example.com:my-secret -H 'Accept:application/yang-data+json' http://bootstrap:"${SZTPD_INIT_PORT}"/restconf/ds/ietf-datastores:running
