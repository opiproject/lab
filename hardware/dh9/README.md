# DPU Host 9

ASUS ESC8000A-E12P

## Firmware and OS

As of 2026-10-21.

| Component                                | Version                                               |
| ---------------------------------------- | ----------------------------------------------------- |
| OS                                       | Fedora Linux 43 (bootc), kernel 7.0.7-100.fc43.x86_64 |
| BIOS                                     | 2403 (04/30/2026)                                     |
| BMC                                      | 1.02.34                                               |
| Intel X710 (e5:00) NVM                   | 9.58 (0x800104bc)                                     |
| Senao SX904 onboard E810-XXV (05:00) NVM | 4.91 (0x8002147d)                                     |
| Intel X710 ASUS OEM (81:00) NVM          | 8.15 (0x8000a3e0)                                     |
| NVMe Samsung MZ1L23T8HBLA                | GDC7502Q                                              |
| Senao SX904 BMC                          | 35.23.10.1003 (recovery 16.3-62)                      |
| Senao SX904 BIOS recovery                | 2.2                                                   |
| Senao SX904 CPLD                         | 22.0                                                  |
| Senao SX904 AFM                          | 1.1                                                   |
| Intel Mount Evans (DYP) IPU              | installed, needs its auxiliary power cable connected  |

## BIOS settings

- change power to always on

## Otel or telegraf

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.31
```
