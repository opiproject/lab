# OPI Lab

[![License](https://img.shields.io/github/license/opiproject/lab?style=flat&color=blue&label=License)](https://github.com/opiproject/lab/blob/main/LICENSE)
[![Linters](https://github.com/opiproject/lab/actions/workflows/linters.yml/badge.svg)](https://github.com/opiproject/lab/actions/workflows/linters.yml)
[![Ansible](https://github.com/opiproject/lab/actions/workflows/ansible.yml/badge.svg)](https://github.com/opiproject/lab/actions/workflows/ansible.yml)
[![CodeQL](https://github.com/opiproject/lab/actions/workflows/codeql.yml/badge.svg)](https://github.com/opiproject/lab/actions/workflows/codeql.yml)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/opiproject/lab/badge)](https://securityscorecards.dev/viewer/?platform=github.com&org=opiproject&repo=lab)
[![GitHub stars](https://img.shields.io/github/stars/opiproject/lab.svg?style=flat-square&label=github%20stars)](https://github.com/opiproject/lab)
[![GitHub Contributors](https://img.shields.io/github/contributors/opiproject/lab.svg?style=flat-square)](https://github.com/opiproject/lab/graphs/contributors)

OPI lab and automation

## I Want To Contribute

This project welcomes contributions and suggestions.  We are happy to have the Community involved via submission of **Issues and Pull Requests** (with substantive content or even just fixes). We are hoping for the documents, test framework, etc. to become a community process with active engagement.  PRs can be reviewed by by any number of people, and a maintainer may accept.

See [CONTRIBUTING](https://github.com/opiproject/opi/blob/main/CONTRIBUTING.md) and [GitHub Basic Process](https://github.com/opiproject/opi/blob/main/doc-github-rules.md) for more details.

## Passwords

We manage all passwords in <https://opi-team.1password.com>

## Access the LAB

- ask in [Opi Slack](https://join.slack.com/t/opi-project/shared_invite/zt-1ctqtrgkz-WJZrcVPp3P1ACZWjpZP2KQ) for initial user/password
- log into [vpn.opiproject-lab.org](http://vpn.opiproject-lab.org) via web browser and change first time password
- either allow the browser based Network Access application to be installed and the VPN will be launched
- or if your company restricts browser-based installs you can:
  - If on Windows, install [F5 Access](./images/f5-vpn-msft-app.png) app from [www.microsoft.com/store/productId/9WZDNCRDSFN0](https://www.microsoft.com/store/productId/9WZDNCRDSFN0)
  - If on Mac, install the F5 Access app from the Mac App store from [apps.apple.com/us/app/f5access/id1243219105](https://apps.apple.com/us/app/f5access/id1243219105)
- create new OPI [VPN connection](./images/add-vpn-windows.png) and enter your new credentials
- test it by going to [https://172.22.4.2/redfish/v1/](https://172.22.4.2/redfish/v1/)

## Links

- [Goals and Requirments](goals-and-requirements.md)
- Setup
  - [Cables/Fibers/transceivers](./Documentation/cables.md)
  - [LAB IPs allocation](./Documentation/ips.md) and [Inventory](./ansible/inventory)
  - [Open Telemetry Observability](./Documentation/otel.md)
  - [Server Software Setup](./Documentation/server-setup.md)
  - [Bill of Materials](./Documentation/bom.md)
  - [Physical Testbed Setup](./Documentation/physical-testbed.md)
    - [ToR - Arista DCS-7280TR-48C6-R](./hardware/ToR/README.md)
    - [TS - Serial Consoles - Avocent ACS8000](./hardware/TS/README.md)
    - [KVM - KVM Switch - Avocent MPU8032DAC](./hardware/KVM/README.md)
    - [VPN - F5 BIG IP i4000](./hardware/VPN/README.md)
    - [nPDU - Network PDU - Vertiv VP7N3001](./hardware/nPDU/README.md)
    - [DH1 - DPU Host 1 - Dell R650](./hardware/dh1/README.md)
    - [DH2 - DPU Host 2 - HPE DL360](./hardware/dh2/README.md)
    - [DH3 - DPU Host 3 - HP RL300](./hardware/dh3/README.md)
    - [DH4 - DPU Host 4 - Dell R760](./hardware/dh4/README.md)
    - [A100G - 100G Switch - Arista DCS-7280CR](./hardware/A100G/README.md)
    - [TGEN1 - Traffic Generator 1 - Supermicro](./hardware/tgen1/README.md)
- [Running the Test Cases](./Documentation/running-the-tests.md)

## Rack diagram

![lab cabling diagram](./images/opi-lab-cabling.drawio.svg)
