# DPU Host 3

HP RL300

## Firmware and OS

As of 2026-10-21.

| Component                             | Version                                     |
| ------------------------------------- | ------------------------------------------- |
| OS                                    | Ubuntu 26.04.1 LTS, kernel 7.0.0-38-generic |
| System ROM                            | R11 v1.60 (03/07/2024)                      |
| iLO 6                                 | 1.79 (Sep 23 2026)                          |
| Ampere System Control Processor (SCP) | 02.10 (02/01/2024)                          |
| Intelligent Platform Abstraction Data | 9.4.0 Build 13                              |
| System Programmable Logic Device      | 0x13 (secondary 0x09)                       |
| Power supplies                        | 2.00                                        |
| 8 SFF NVMe UBM4 backplane             | 1.28                                        |
| TPM                                   | 1.512                                       |
| ConnectX-6 Lx                         | 26.49.1014 (MT_0000000575)                  |
| NVMe VO001920KYDMT                    | HPK6                                        |
| DOCA (doca-ofed)                      | 3.5.0-082000                                |
| OFED / mft / rshim                    | 26.07-0.7.7 / 4.37.0-154 / 2.8.5-1          |
| Docker                                | 29.9.1                                      |
| Marvell CN106 Linux                   | Buildroot 2022.08.2, kernel 5.15.72         |
| Marvell CN106 SDK                     | 12.24.03                                    |
| Marvell CN106 U-Boot                  | 2023.01-12.24.03                            |
| Marvell CN106 MCU                     | 1.6.0                                       |

## BIOS settings

- change power to always on

## Link speed

an aditional service was created in order to set the nic at boot in 1G mode
otherwise it starts in 10G/25G mode and link will be down

- run manually:

```bash
ethtool -s enP2p1s0f0np0 speed 1000
```

- or via systemctl

```bash
systemctl edit  --force --full link-speed.service
systemctl enable link-speed.service
systemctl start link-speed.service
```

where `link-speed.service` is:

```ini
[Unit]
After=network.target

[Service]
ExecStart=ethtool -s enP2p1s0f0np0 speed 1000

[Install]
WantedBy=default.target
```

## Otel or telegraf

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.31
```

## Marvell

lspci

```bash
root@dh3:~# lspci | grep Cavium
0003:01:00.0 Network controller: Cavium, Inc. Device b900
```

usb

```bash
root@dh3:~# lsusb | grep CP2105
Bus 002 Device 005: ID 10c4:ea70 Silicon Labs CP2105 Dual UART Bridge
```

uart over usb

```bash
root@dh3:~# ls -l  /dev/ttyUSB*
crw-rw---- 1 root dialout 188, 0 May 30 14:26 /dev/ttyUSB0
crw-rw---- 1 root dialout 188, 1 May 28 02:14 /dev/ttyUSB1
```

CN106 Linux version, on the Linux console (`/dev/ttyUSB0`)

```bash
root@dh3:~# minicom -D /dev/ttyUSB0

# cat /etc/os-release
# uname -r
```

MCU version, on the MCU's Zephyr shell (`/dev/ttyUSB1`)

```bash
root@dh3:~# minicom -D /dev/ttyUSB1

uart:~$ version
```

The current values are in the table at the top.
