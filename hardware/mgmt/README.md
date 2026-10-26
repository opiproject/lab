# Management server

## Roles

- DHCP server for the lab
- GitHub self hosted runners
- OTEL, Prometheus and Grafana servers for the lab monitoring
- SZTP bootstrap server for the lab
- network gateway between private network 172.22 and the internet
- Other containers and vms for remaining services

## Firmware and OS

As of 2026-10-21.

| Component                 | Version                                     |
| ------------------------- | ------------------------------------------- |
| OS                        | Ubuntu 26.04.1 LTS, kernel 7.0.0-38-generic |
| BIOS                      | F48 (R35_F48, 09/03/2026)                   |
| BMC                       | 13.06.29                                    |
| Intel E810-CQDA2 OCP3 NVM | 5.10 (0x80022600), FW 1.4113.0              |
| Intel I210 NVM            | 3.30 (0x8000079c)                           |
| Kea DHCPv4                | 3.0.3                                       |

## BIOS settings

- change power to always on

## Network interface names

The NIC names are pinned to their MAC addresses with `/etc/systemd/network/10-pin-<name>.link` files (also copied into
the initramfs), so a BIOS or kernel update that renumbers PCI buses cannot rename them. `enp195s0` carries the public IP
and the NAT, and `enp1s0f0np0` serves the lab DHCP.

## Containers

As of 2026-10-20 mgmt has no Docker or Podman installed, only LXC. The `docker compose` steps below are from the earlier
setup.

## DHCP server

Kea `kea-dhcp4-server` 3.0.3, bare metal, since 2026-10-20. isc-dhcp-server is disabled.

- Config: [kea-dhcp4.conf](fs/etc/kea/kea-dhcp4.conf). It listens on the lab NIC `enp1s0f0np0` only, with one reservation per
  device in [ips.md](../../Documentation/ips.md) and a pool of 172.22.222.1-254 for unknown devices.
- SZTP option 143 is sent with the `flex_option` hook.
- Check the config before a restart: `kea-dhcp4 -t /etc/kea/kea-dhcp4.conf`.
- Leases: `/var/lib/kea/kea-leases4.csv`.

## NAT and firewall

`nftables.service` is disabled on purpose, because [nftables.conf](fs/etc/nftables.conf) starts with a flush that would drop
the NAT rules. mgmt masquerades the lab traffic out of `enp195s0`:

```bash
iptables -t nat -A POSTROUTING -o enp195s0 -j MASQUERADE
```

fail2ban guards sshd, see [opilab.local](fs/etc/fail2ban/jail.d/opilab.local).

## GitHub self hosted runners

Follow GitHub [instructions](https://github.com/opiproject/opi-poc/settings/actions/runners/new?arch=x64&os=linux)

## Ansible

- Run `docker compose up -d semaphore` or `docker-compose up -d semaphore` from the repo root (see [OTEL](../../Documentation/otel.md)).
- This will start [Ansible Semaphore](https://docs.semui.co).
- Access it via <http://172.22.0.1:4000/>

## Portainer

- Run `docker compose up -d portainer` or `docker-compose up -d portainer` from the repo root (see [OTEL](../../Documentation/otel.md)).
- This will start [Portainer Community Edition](https://www.portainer.io/).
- Access it via <http://172.22.0.1:9000/>

## Monitoring & Telemetry

Run `docker compose up -d` or `docker-compose up -d` from the repo root (see [OTEL](../../Documentation/otel.md))

1. [OTEL Gateway Collector](https://opentelemetry.io/docs/collector/deployment/gateway/) to aggregate telemetry from all DPUs and IPUs.
2. [Prometheus](https://prometheus.io/) Monitoring system & time series database
3. [Grafana](https://grafana.com/) Open source analytics & monitoring solution for every database.

Acccess it via:

1. <http://172.22.0.1:8889/metrics>
2. <http://172.22.0.1:9091/>
3. <http://172.22.0.1:3000/>

## Paswordless

for all servers, DPUs and IPUs listed in [ips.md](../../Documentation/ips.md) run:

```bash
 ssh-copy-id root@172.22.X.X
```
