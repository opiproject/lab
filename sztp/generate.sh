#!/usr/bin/bash

set -euxo pipefail

NVIDIA_BOOT_IMG_HASH_VAL=`openssl dgst -sha256 -c   nvidia-boot-image.img | awk '{print $2}'` \
NVIDIA_PRE_SCRIPT_B64=`openssl enc -base64 -A -in   nvidia-pre-configuration-script.sh` \
NVIDIA_POST_SCRIPT_B64=`openssl enc -base64 -A -in  nvidia-post-configuration-script.sh` \
NVIDIA_CONFIG_B64=`openssl enc -base64 -A -in       nvidia-configuration.xml` \
INTEL_BOOT_IMG_HASH_VAL=`openssl dgst -sha256 -c    intel-boot-image.img | awk '{print $2}'` \
INTEL_PRE_SCRIPT_B64=`openssl enc -base64 -A -in    intel-pre-configuration-script.sh` \
INTEL_POST_SCRIPT_B64=`openssl enc -base64 -A -in   intel-post-configuration-script.sh` \
INTEL_CONFIG_B64=`openssl enc -base64 -A -in        intel-configuration.xml` \
MARVELL_BOOT_IMG_HASH_VAL=`openssl dgst -sha256 -c  marvell-boot-image.img | awk '{print $2}'` \
MARVELL_PRE_SCRIPT_B64=`openssl enc -base64 -A -in  marvell-pre-configuration-script.sh` \
MARVELL_POST_SCRIPT_B64=`openssl enc -base64 -A -in marvell-post-configuration-script.sh` \
MARVELL_CONFIG_B64=`openssl enc -base64 -A -in      marvell-configuration.xml` \
SBI_PRI_KEY_B64=`openssl enc -base64 -A -in         private_key.der` \
SBI_PUB_KEY_B64=`openssl enc -base64 -A -in         public_key.der` \
SBI_EE_CERT_B64=`openssl enc -base64 -A -in         cert_chain.cms` \
CLIENT_CERT_TA_B64=`openssl enc -base64 -A -in      ta_cert_chain.cms` \
envsubst '$NVIDIA_BOOT_IMG_HASH_VAL,$NVIDIA_PRE_SCRIPT_B64,$NVIDIA_POST_SCRIPT_B64,$NVIDIA_CONFIG_B64,$INTEL_BOOT_IMG_HASH_VAL,$INTEL_PRE_SCRIPT_B64,$INTEL_POST_SCRIPT_B64,$INTEL_CONFIG_B64,$MARVELL_BOOT_IMG_HASH_VAL,$MARVELL_PRE_SCRIPT_B64,$MARVELL_POST_SCRIPT_B64,$MARVELL_CONFIG_B64,$CLIENT_CERT_TA_B64,$SBI_PRI_KEY_B64,$SBI_PUB_KEY_B64,$SBI_EE_CERT_B64' < template.json > config.json

diff template.json config.json
