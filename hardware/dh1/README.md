# DPU Host 1

Dell PowerEdge R650

## BIOS settings

- change power to always on

## Otel or telegraf

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.29
```

## Pensando

lspci

```bash
root@dh1:~# lspci -d 1dd8:1002
19:00.0 Ethernet controller: AMD Pensando Systems DSC Ethernet Controller
1a:00.0 Ethernet controller: AMD Pensando Systems DSC Ethernet Controller

root@dh1:~# lspci | grep Pensando
17:00.0 PCI bridge: AMD Pensando Systems DSC2 Elba Upstream Port
18:00.0 PCI bridge: AMD Pensando Systems DSC Virtual Downstream Port
18:01.0 PCI bridge: AMD Pensando Systems DSC Virtual Downstream Port
18:02.0 PCI bridge: AMD Pensando Systems DSC Virtual Downstream Port
19:00.0 Ethernet controller: AMD Pensando Systems DSC Ethernet Controller
1a:00.0 Ethernet controller: AMD Pensando Systems DSC Ethernet Controller
1b:00.0 Ethernet controller: AMD Pensando Systems DSC Management Controller
```

serial and mac

```bash
root@dh1:~# lspci -vvv -s 1b:00.0 | grep -A 19 "Vital Product Data"
        Capabilities: [c0] Vital Product Data
                Product Name: Pensando DSC2-100 100G 2p QSFP56 DPU
                Read-only fields:
                        [PN] Part number: 0PCFPCA00
                        [SN] Serial number: MYFLEPK31D02ZH
                        [EC] Engineering changes: 0
                        [MN] Manufacture ID: 1028
                        [V3] Vendor specific: 1.46.0-E-28
                        [V4] Vendor specific: 00aecd5be7ee
                        [V5] Vendor specific: MKY=V0-d78e97440a382c8825cd4320627bba5d
                        [VA] Vendor specific: DSV1028VPDR.VER2.2
                        [VB] Vendor specific: NMVPensando Systems
                        [VC] Vendor specific: FFV01.46.00.28
                        [VD] Vendor specific: DTINIC
                        [VE] Vendor specific: NPY1
                        [VF] Vendor specific: PMTD
                        [VG] Vendor specific: DCM3001FFFFFF
                        [VH] Vendor specific: UUID1dd8000000004000800000aecd5be7ec
                        [RV] Reserved: checksum good, 128 byte(s) reserved
                End
```

drivers

```bash
root@dh1:~# dmesg | grep ionic
[    2.462867] integrity: Loaded X.509 cert 'pensando: ionic.ko: 1941fcb3df8deb68fe3aed35aab0f867032935c9'
[    2.804739] ionic 0000:19:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
[    2.808758] ionic 0000:19:00.0: FW: 1.46.0-E-28
[    3.253894] ionic 0000:1a:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
[    3.260512] ionic 0000:1a:00.0: FW: 1.46.0-E-28
[    3.450751] ionic 0000:1a:00.0 enp26s0np0: renamed from eth1
[    3.459006] ionic 0000:19:00.0 enp25s0np0: renamed from eth0

root@dh1:~# ls -l  /sys/class/net/*/device
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/eno12399np0/device -> ../../../0000:31:00.0
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/eno12409np1/device -> ../../../0000:31:00.1
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/enp25s0np0/device -> ../../../0000:19:00.0
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/enp26s0np0/device -> ../../../0000:1a:00.0
lrwxrwxrwx 1 root root 0 May 30 17:45 /sys/class/net/idrac/device -> ../../../1-14.3:1.0

root@dh1:~# ls -l  /sys/class/net/*/device/driver
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/eno12399np0/device/driver -> ../../../../bus/pci/drivers/bnxt_en
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/eno12409np1/device/driver -> ../../../../bus/pci/drivers/bnxt_en
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/enp25s0np0/device/driver -> ../../../../../../bus/pci/drivers/ionic
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/enp26s0np0/device/driver -> ../../../../../../bus/pci/drivers/ionic
lrwxrwxrwx 1 root root 0 May 29 23:10 /sys/class/net/idrac/device/driver -> ../../../../../../../bus/usb/drivers/cdc_ether
```

network

```bash
root@dh1:~# ethtool -i enp25s0np0
driver: ionic
version: 6.8.0-31-generic
firmware-version: 1.46.0-E-28
expansion-rom-version:
bus-info: 0000:19:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no

root@dh1:~# devlink dev info pci/0000:19:00.0
pci/0000:19:00.0:
  driver ionic
  serial_number MYFLEPK31D02ZH
  versions:
      fixed:
        asic.id 0x0
        asic.rev 0x0
      running:
        fw 1.46.0-E-28

root@dh1:~# ifconfig
...
enp25s0np0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 00:ae:cd:5b:e7:ec  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp26s0np0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 00:ae:cd:5b:e7:ed  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 278  bytes 31807 (31.8 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 278  bytes 31807 (31.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
