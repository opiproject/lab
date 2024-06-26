# DPU Host 2

HPE DL360

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
