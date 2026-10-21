# DPU Host 5

Dell R760ax

## DPU

Nvidia Blue Filed 3

## Firmware and OS

As of 2026-10-21.

| Component                             | Version                                             |
| ------------------------------------- | --------------------------------------------------- |
| OS                                    | Ubuntu 26.04.1 LTS, kernel 7.0.0-38-generic         |
| BIOS                                  | 2.11.4 (09/16/2026)                                 |
| iDRAC 9 and Lifecycle Controller      | 7.30.30.54                                          |
| System CPLD                           | 1.3.2                                               |
| Backplane 1                           | 1.75                                                |
| Broadcom Adv. Dual 10GBASE-T Ethernet | 38.11.70.00                                         |
| Broadcom BCM5720 1GbE                 | 23.81.6                                             |
| Dell NVMe PM1743 RI E3.S 3.84TB       | 1.3.0                                               |
| Power supplies                        | 00.23.54                                            |
| iDRAC Service Module                  | 5.3.0.0                                             |
| Dell OS Driver Pack                   | 26.08.02                                            |
| Dell 64-bit uEFI Diagnostics          | 4303A52                                             |
| DOCA (doca-ofed) / OFED / mft         | 3.5.0 / 26.07-0.7.7 / 4.37.0-154                    |
| BlueField-3 NIC firmware              | 32.50.1002 (MT_0000000884)                          |
| BlueField-3 Arm OS                    | Ubuntu 24.04.4 LTS, kernel 6.8.0-1030-bluefield-64k |
| BlueField-3 BFB                       | bf-bundle-3.5.0-89_26.07_ubuntu-24.04_64k_prod      |
| BlueField-3 Arm OFED / mft            | 26.07-0.7.7 / 4.37.0-154                            |
| BlueField-3 UEFI / ATF / BSP          | 4.16.0-48 / 4.16.0-8 / 4.16.0.14075                 |
| BlueField-3 BMC                       | BF-26.07-8                                          |
| BlueField-3 ERoT                      | 00.02.0208.0000_n02                                 |
| BlueField-3 NVMe KBG40ZPZ128G         | AEGA0103                                            |

## BIOS settings

- change power to always on

## Otel or telegraf

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.31
```
