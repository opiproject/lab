#!/usr/bin/bash

set -euo pipefail

MYTMPDIR="$(mktemp -d)"
trap 'rm -rf -- "$MYTMPDIR"' EXIT

curl -kL https://watsen.net/support/sztpd-simulator-0.0.11.tgz | tar -zxvf - -C "${MYTMPDIR}"/
pushd "${MYTMPDIR}"/sztpd-simulator/pki
# SBI Port certificates
{
    echo "DNS.2 = bootstrap"
    echo "DNS.3 = web"
    echo "DNS.4 = redirecter"
} >> sztpd1/sbi/end-entity/openssl.cnf
make -C sztpd1/sbi pki
cat sztpd1/sbi/end-entity/my_cert.pem sztpd1/sbi/intermediate2/my_cert.pem > "${MYTMPDIR}"/sztpd-simulator/cert_chain.pem
openssl crl2pkcs7 -nocrl -certfile "${MYTMPDIR}"/sztpd-simulator/cert_chain.pem -outform DER -out "${MYTMPDIR}"/sztpd-simulator/cert_chain.cms
# client cert DevID trust anchors
make -C client pki
cat client/root-ca/my_cert.pem client/intermediate1/my_cert.pem client/intermediate2/my_cert.pem > "${MYTMPDIR}"/sztpd-simulator/ta_cert_chain.pem
openssl crl2pkcs7 -nocrl -certfile "${MYTMPDIR}"/sztpd-simulator/ta_cert_chain.pem -outform DER -out "${MYTMPDIR}"/sztpd-simulator/ta_cert_chain.cms
# ???
cat sztpd1/sbi/root-ca/my_cert.pem sztpd1/sbi/intermediate1/my_cert.pem > "${MYTMPDIR}"/sztpd-simulator/opi.pem
popd

# copy locally for server
rm -rf ./generated-server
mkdir -p ./generated-server
cp "${MYTMPDIR}"/sztpd-simulator/pki/sztpd1/sbi/end-entity/*.pem ./generated-server/
cp "${MYTMPDIR}"/sztpd-simulator/pki/sztpd1/sbi/end-entity/{private,public}_key.der ./generated-server/
cp "${MYTMPDIR}"/sztpd-simulator/cert_chain.{pem,cms} ./generated-server/
cp "${MYTMPDIR}"/sztpd-simulator/ta_cert_chain.{pem,cms} ./generated-server/
chmod -R a+r ./generated-server

# copy remotely for clients
rm -rf ./generated-client
mkdir -p ./generated-client
cp "${MYTMPDIR}"/sztpd-simulator/opi.pem ./generated-client/opi.pem
for vendor in nvidia intel marvell amd; do
    sed -i "s/my-serial-number/${vendor}-serial-number/g" "${MYTMPDIR}"/sztpd-simulator/pki/client/end-entity/openssl.cnf
    make -C "${MYTMPDIR}"/sztpd-simulator/pki/client/end-entity    cert_request      OPENSSL=openssl
    make -C "${MYTMPDIR}"/sztpd-simulator/pki/client/intermediate2 sign_cert_request OPENSSL=openssl REQDIR="../end-entity"
    cp "${MYTMPDIR}"/sztpd-simulator/pki/client/end-entity/private_key.pem ./generated-client/${vendor}_private_key.pem
    cp "${MYTMPDIR}"/sztpd-simulator/pki/client/end-entity/my_cert.pem ./generated-client/${vendor}_my_cert.pem
    sed -i "s/${vendor}-serial-number/my-serial-number/g" "${MYTMPDIR}"/sztpd-simulator/pki/client/end-entity/openssl.cnf
done
chmod -R a+r ./generated-client

echo ==================================
echo "Now COPY client files to the remote clients:"
echo scp ./generated-client/*.pem root@172.22.3.2:/mnt/
echo ==================================
