# Top of Rack

ToR switch/router provides network conectivity for management and access to the lab devices. All non test traffic goes through this device.

## HW spec

- Part Number: Arista DCS-7280TR-48C6-R
- Hardware version: 11.04
- Software image version: 4.22.3M

```bash
tor>show vers
Arista DCS-7280TR-48C6-R
Hardware version:    11.04
Serial number:       SSJ18302393
System MAC address:  2899.3a9c.3965

Software image version: 4.22.3M
Architecture:           i686
Internal build version: 4.22.3M-14418192.4223M
Internal build ID:      a077fcd6-7c48-4b5d-9d76-bd5f7a250bd5

Uptime:                 16 weeks, 2 days, 6 hours and 37 minutes
Total memory:           8104364 kB
Free memory:            6384448 kB
```

## Management

- serial port
- 1G ethernet management port

## gNMI

```bash
enable
configure
management api gnmi
   transport grpc openmgmt
      port 5900
```

and

```bash
tor#show management api gnmi
Enabled:            Yes
Server:             running on port 5900, in default VRF
SSL Profile:        none
```

## Docs

[Data Sheet](https://www.arista.com/assets/data/pdf/Datasheets/7280R-DataSheet.pdf)

## Pictures

![front](front.png)

![back](back.png)
