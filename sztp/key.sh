#!/usr/bin/bash

set -euo pipefail

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

echo "Now COPY client files to the remote clients:"
echo scp ./generated-client/opi*.pem root@172.22.3.2:/mnt/
