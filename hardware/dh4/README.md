# DPU Host 4

Dell PowerEdge R760

## Firmware and OS

As of 2026-10-21.

| Component                             | Version                                     |
| ------------------------------------- | ------------------------------------------- |
| OS                                    | Ubuntu 26.04.1 LTS, kernel 7.0.0-38-generic |
| BIOS                                  | 2.11.4 (09/16/2026)                         |
| iDRAC 9 and Lifecycle Controller      | 7.30.30.54                                  |
| System CPLD                           | 1.1.0                                       |
| Backplane 1                           | 7.20                                        |
| Broadcom Adv. Dual 10GBASE-T Ethernet | 38.11.70.00                                 |
| Dell DC NVMe ISE 7450 RI U.2 1.92TB   | 1.4.0                                       |
| Power supplies                        | 00.18.31                                    |
| iDRAC Service Module                  | 6.1.1.0                                     |
| Dell OS Driver Pack                   | 26.08.02                                    |
| Dell 64-bit uEFI Diagnostics          | 4303A52                                     |
| Intel IPU E2100 (MacKay Peak)         | SDK 2.2.0 build 12025 (IMC and ACC)         |

## BIOS settings

- change power to always on

## IPU

Intel IPU E2100 (MacKay Peak). Its IMC is at 172.22.4.4 on the lab network, and the ACC is
reached through the IMC at 192.168.0.2.

- to enable port forwarding for `OTEL` from `ACC` through `IMC`, run manually:

```bash
dnf install -y socat
socat tcp-l:4317,fork,reuseaddr tcp:172.22.0.1:4317
```

- or via systemctl

```bash
systemctl edit  --force --full socat-otel.service
systemctl enable socat-otel.service
systemctl start socat-otel.service
```

where `socat-otel.service` is:

```ini
[Unit]
After=network.target

[Service]
ExecStart=socat tcp-l:4317,fork,reuseaddr tcp:172.22.0.1:4317

[Install]
WantedBy=default.target
```

## Otel or telegraf

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.31
```
