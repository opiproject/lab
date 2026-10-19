# IP Allocations

All lab addressing uses the 172.22.0.0/16 network. One gateway (mgmt, 172.22.0.1) handles
internet access (NAT) and is the entry point into the lab (VPN). Public addressing is kept
in the private lab repo.

Last verified 2026-10-19 (ARP sweep from mgmt, ToR MAC table, DHCP leases).

## Code duplication

:exclamation: with [ansible inventory](../ansible/inventory) and
[dhcpd.conf](../hardware/mgmt/fs/etc/dhcp/dhcpd.conf) (the `dhcpd host` column below)

## Device types ip allocation

| IP Range            | Purpose                                                     |
|-----------------    |---------------------------------------------------------    |
| 172.22.0.0/24       | All management devices like, gateway, kvm, ts, pdu, ...     |
| 172.22.1.0/24       | All servers, dpu hosts, test, ...                           |
| 172.22.2.0/24       | All iDRAC, iLO, BMC...                                      |
| 172.22.3.0/24       | All DPUs                                                    |
| 172.22.4.0/24       | All BMC of the DPU                                          |
| 172.22.222.0/24     | dhcp allocated to any unknown device                        |
| 172.22.254.0/24     | VPN Lease Pool -- IPs dynamically assigned to VPN clients   |

## Per Device IP allocation

| IPv4                          | IPv6     | DEVICE                                   | dhcpd host     | Helpful URLs   |
|---------------------------    |------    |----------------------------------------- |--------------- |----------------|
| public ip / 172.22.0.1        |          | gateway/mgmt                             | (static)       | <http://172.22.0.1:9091/> and <http://172.22.0.1:3000/> |
| 172.22.0.5                    |          | ToR, Arista DCS-7280TR-48C6-R            | tor            |                                  |
| 172.22.0.10                   |          | Network PDU                              | npdu           |                                  |
| 172.22.0.20                   |          | KVM                                      | kvm            |                                  |
| 172.22.0.30                   |          | TS, Vertiv Avocent ACS8000               | ts             |                                  |
| 172.22.0.227                  |          | F5 BIG-IP-01 (F5A), internal             | (static)       |                                  |
| 172.22.0.228                  |          | F5 BIG-IP-02 (F5B), internal             | (static)       |                                  |
| 172.22.0.229                  |          | F5 BIG-IP floating, internal             | (static)       |                                  |
|                               |          |                                          |                |                                  |
| 172.22.1.1                    |          | DPU Host 1                               | dh1            |                                  |
| 172.22.2.1                    |          | DH1 iDRAC                                | dh1idrac       | <https://172.22.2.1/redfish/v1/> |
| 172.22.3.1                    |          | AMD DSC200                               | (none yet)     |                                  |
|                               |          |                                          |                |                                  |
| 172.22.1.2                    |          | DPU Host 2                               | dh2            |                                  |
| 172.22.2.2                    |          | DH2 iLO                                  | dh2ilo         | <https://172.22.2.2/redfish/v1/> |
| 172.22.3.2                    |          | Nvidia BF2                               | dh2bf2         |                                  |
| 172.22.4.2                    |          | Nvidia BF2 bmc                           | dh2bf2bmc      | <https://172.22.4.2/redfish/v1/> |
|                               |          |                                          |                |                                  |
| 172.22.1.3                    |          | DPU Host 3                               | dh3            |                                  |
| 172.22.2.3                    |          | DH3 iLO                                  | dh3ilo         | <https://172.22.2.3/redfish/v1/> |
| 172.22.3.3                    |          | Marvell CN106 (reserved, see note 1)     | (none)         |                                  |
| 172.22.4.3                    |          | Marvell CN106 MCU (Zephyr)               | dh3cn106mcu    |                                  |
|                               |          |                                          |                |                                  |
| 172.22.1.4                    |          | DPU Host 4                               | dh4            |                                  |
| 172.22.2.4                    |          | DH4 iDRAC                                | dh4idrac       | <https://172.22.2.4/redfish/v1/> |
| 172.22.4.4                    |          | Intel IPU E2100 (MacKay Peak) IMC, see note 2 | dh4e2100imc |                                  |
|                               |          |                                          |                |                                  |
| 172.22.1.5                    |          | DPU Host 5                               | dh5            |                                  |
| 172.22.2.5                    |          | DH5 iDRAC                                | dh5idrac       | <https://172.22.2.5/redfish/v1/> |
| 172.22.3.5                    |          | Nvidia BF3, see note 3                   | dh5bf3         |                                  |
| 172.22.4.5                    |          | Nvidia BF3 bmc                           | dh5bf3bmc      | <https://172.22.4.5/redfish/v1/> |
|                               |          |                                          |                |                                  |
| 172.22.1.9                    |          | DPU Host 9                               | dh9            |                                  |
| 172.22.2.9                    |          | DH9 BMC, dedicated port                  | dh9bmc         | <https://172.22.2.9/redfish/v1/> |
| 172.22.2.109                  |          | DH9 BMC, shared host NIC (NC-SI)         | dh9bmcshared   |                                  |
| 172.22.3.9                    |          | Intel Mount Evans (DYP), see note 4      | dh9dpu         |                                  |
| 172.22.4.9                    |          | Intel Mount Evans on-card BMC            | dh9dpubmc      |                                  |
|                               |          |                                          |                |                                  |
| 172.22.1.100                  |          | Tgen1                                    | tgen1          |                                  |
| 172.22.2.100                  |          | Tgen1 bmc                                | tgen1bmc       | <https://172.22.2.100/redfish/v1/> |
|                               |          |                                          |                |                                  |
| 172.22.1.250                  |          | Arista 100G                              | arista100g     |                                  |

Notes:

1. The CN106 Linux has no out-of-band link; use its console on DH3 `/dev/ttyUSB0`. The
   RJ45 on the card belongs to the MCU, whose console is DH3 `/dev/ttyUSB1`.
2. DH4 was listed with an "Intel DYP" card; it now holds the E2100. Its ACC is reached
   through the IMC at 192.168.0.2 (see `mev` in the ansible inventory).
3. The BF3 Arm (`oob_net0`) and its BMC share one RJ45.
4. Moved from DH4 to DH9. Not yet logged in to verify.

The F5 BIG-IP management ports are on 192.168.0.227 (F5A) and 192.168.0.228 (F5B),
reachable from mgmt (192.168.0.230).
