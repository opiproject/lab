# DPU Host 3

HP RL300

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
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.29
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

CPU version

```bash
root@dh3:~# minicom -D /dev/ttyUSB0

root@ubuntu-server:~# head -n 2 /etc/os-release
NAME="Ubuntu"
VERSION="20.04 LTS (Focal Fossa)"
```

IMC version

```bash
root@dh3:~# minicom -D /dev/ttyUSB0

uart:~$ version
Version 1.05
Built at 2023-09-27T15:19:47 Wednesday local time against board cn103_pcie_crb
```
