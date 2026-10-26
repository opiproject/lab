# DPU Host 2

HPE DL360

## Firmware and OS

As of 2026-10-21.

| Component                             | Version                                          |
| ------------------------------------- | ------------------------------------------------ |
| OS                                    | Ubuntu 26.04.1 LTS, kernel 7.0.0-38-generic      |
| System ROM                            | U46 v2.70 (08/19/2026)                           |
| Redundant System ROM                  | U46 v1.80 (07/05/2023)                           |
| iLO 5                                 | 3.22 (Sep 21 2026)                               |
| Server Platform Services (SPS)        | 4.4.4.926                                        |
| Innovation Engine                     | 1.0.0.22                                         |
| Intelligent Platform Abstraction Data | 13.3.0 Build 37                                  |
| Intelligent Provisioning              | 3.88.6                                           |
| Power Management Controller           | 1.1.4                                            |
| System Programmable Logic Device      | 0x16                                             |
| Power supplies                        | 2.00                                             |
| 8 SFF NVMe UBM4 backplane             | 1.28                                             |
| TPM                                   | 73.64                                            |
| BCM57414 10/25Gb OCP3 adapter         | 238.1.169.0                                      |
| NVMe MO001600KYDMU                    | HPK6                                             |
| BlueField-2 card NIC firmware         | 24.41.1000 (MT_0000000733)                       |
| DOCA (doca-all)                       | 3.5.0-082000                                     |
| OFED / mft / rshim                    | 26.07-0.7.7 / 4.37.0-154 / 2.8.5-1               |
| Docker                                | 29.9.2                                           |
| BlueField-2 Arm OS                    | Ubuntu 22.04.5 LTS, kernel 5.15.0-1042-bluefield |
| BlueField-2 BFB                       | bf-bundle-2.7.0-33_24.04_ubuntu-22.04            |
| BlueField-2 Arm MLNX_OFED / mft       | 24.04-0.6.6 / 4.28.0-92                          |
| BlueField-2 UEFI                      | 4.7.0.13127                                      |
| BlueField-2 BMC                       | BF-24.04-5                                       |
| BlueField-2 ERoT                      | 4-15                                             |

## Link speed

`ens10f0np0` reaches the ToR through an FS 1000BASE-T copper SFP. Broadcom firmware 38.x / 238.1.x will not
link it with autonegotiation on, so [10-ens10f0np0-1g.link](fs/etc/systemd/network/10-ens10f0np0-1g.link) forces 1G full duplex.
Copy it to `/etc/systemd/network/` and reboot (or `udevadm trigger`).

## BIOS settings

- change power to always on

## Otel or telegraf

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.31
```

## Nvidia

lspci

```bash
root@dh2:~# lspci | grep BlueField-2
0f:00.0 Ethernet controller: Mellanox Technologies MT42822 BlueField-2 integrated ConnectX-6 Dx network controller (rev 01)
0f:00.1 Ethernet controller: Mellanox Technologies MT42822 BlueField-2 integrated ConnectX-6 Dx network controller (rev 01)
0f:00.2 DMA controller: Mellanox Technologies MT42822 BlueField-2 SoC Management Interface (rev 01)
```

serial

```bash
root@dh2:~# lspci -vvv -s 0f:00.2 | grep -A 11 "Vital Product Data"
        Capabilities: [48] Vital Product Data
                Product Name: BlueField-2 E-Series DPU 100GbE Dual-Port QSFP56, integrated BMC, Secure Boot Enabled, Crypto Enabled, 16GB on-board DDR, 1GbE OOB management, FHHL            
                Read-only fields:
                        [PN] Part number: MBF2M516C-CECOT
                        [EC] Engineering changes: A9
                        [V2] Vendor specific: MBF2M516C-CECOT
                        [SN] Serial number: MT2321XZ0KVX
                        [V3] Vendor specific: 1814c074ae05ee118000946daeb98570
                        [VA] Vendor specific: MLX:MN=MLNX:CSKU=V2:UUID=V3:PCI=V0:MODL=BF2M516C
                        [V0] Vendor specific: PCIeGen4 x16
                        [RV] Reserved: checksum good, 1 byte(s) reserved
                End
```

rshim

```bash
root@dh2:~# cat /dev/rshim0/misc
DISPLAY_LEVEL   0 (0:basic, 1:advanced, 2:log)
BOOT_MODE       1 (0:rshim, 1:emmc, 2:emmc-boot-swap)
BOOT_TIMEOUT    150 (seconds)
DROP_MODE       0 (0:normal, 1:drop)
SW_RESET        0 (1: reset)
DEV_NAME        pcie-0000:0f:00.2
DEV_INFO        BlueField-2(Rev 1)
OPN_STR         N/A
```

ssh over rshim

```bash
root@dh2:~# ifconfig tmfifo_net0 192.168.100.1/30 up
root@dh2:~# ping 192.168.100.2
root@dh2:~# ssh ubuntu@192.168.100.2
```

flush new BFB image

```bash
root@dh2:~# wget https://content.mellanox.com/BlueField/BFBs/Ubuntu22.04/bf-bundle-2.7.0-33_24.04_ubuntu-22.04_prod.bfb
root@dh2:~# cat bf-bundle-2.7.0-33_24.04_ubuntu-22.04_prod.bfb > /dev/rshim0/boot
```
