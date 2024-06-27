# 100G Switch

This device is intended to mold the test traffic between the trafic generators and the devices under test

[Howto upgrade](https://www.arista.com/en/um-eos/eos-standard-upgrades-and-downgrades#prepare_the_switch_for_ssu)

## HW spec

Arista 7280R, 48x100GbE QSFP and 8x40GbE QSFP+ switch, front to rear air, 2 x AC and 2 x C19-C20 cords

- Part number: Arista DCS-7280CR-48-F
- Hardware version: 11.01
- Software image version: 4.32.0F

```bash
A100G>show version
Arista DCS-7280CR-48-F
Hardware version: 11.01
Serial number: JPE16491339
Hardware MAC address: 444c.a897.b5cf
System MAC address: 444c.a897.b5cf

Software image version: 4.32.0F
Architecture: i686
Internal build version: 4.32.0F-36401836.4320F
Internal build ID: 6217eea5-c8bc-4ca0-a5d9-7f4c1d4f8e78
Image format version: 3.0
Image optimization: Sand-4GB

Uptime: 1 week, 5 days, 2 hours and 55 minutes
Total memory: 16253824 kB
Free memory: 13076216 kB
```

## Management

- serial port
- 1G ethernet management port

## Docs

[7280R-DataSheet](https://www.arista.com/assets/data/pdf/Datasheets/7280R-DataSheet.pdf)

## Config

[Config](arista.config)

## Pictures

![front](front.jpg)

![back](back.png)

## gNMI

```bash
enable
configure
management api gnmi
   transport grpc openmgmt
      port 5900
   provider eos-native
```

and

```bash
A100G>show management api gnmi
Octa: enabled

Transport: default
Enabled: yes
Server: running on port 5900, in default VRF
SSL profile: none
QoS DSCP: none
Authorization required: no
Accounting requests: no
Notification timestamp: last change time
Listen addresses: ::
Authentication username priority: x509-spiffe, metadata, x509-common-name
```

test

```bash
root@dh1:~# docker run --network host --rm ghcr.io/openconfig/gnmic get --log --username arista --password arista --insecure --address 172.22.1.250 --port 5900 --path /openconfig-interfaces:interfaces/interface[name=Management1]/state
2024/05/16 18:50:27.749705 [gnmic] version=0.37.0, commit=05a3e785, date=2024-05-13T23:27:31Z, gitURL=https://github.com/openconfig/gnmic, docs=https://gnmic.openconfig.net
2024/05/16 18:50:27.749742 [gnmic] using config file ""
2024/05/16 18:50:27.750028 [gnmic] sending gNMI GetRequest: prefix='<nil>', path='[elem:{name:"openconfig-interfaces:interfaces"}  elem:{name:"interface"  key:{key:"name"  value:"Management1"}}  elem:{name:"state"}]', type='ALL', encoding='JSON', models='[]', extension='[]' to 172.22.1.250
2024/05/16 18:50:27.750656 [gnmic] creating gRPC client for target "172.22.1.250"
[
  {
    "source": "172.22.1.250",
    "time": "1970-01-01T00:00:00Z",
    "updates": [
      {
        "Path": "interfaces/interface[name=Management1]/state",
        "values": {
          "interfaces/interface/state": {
            "arista-intf-augments:inactive": false,
            "openconfig-interfaces:admin-status": "UP",
            "openconfig-interfaces:counters": {
              "in-broadcast-pkts": "36076006",
              "in-discards": "0",
              "in-errors": "0",
              "in-multicast-pkts": "184661",
              "in-octets": "10041381967",
              "in-unicast-pkts": "93505125",
              "out-broadcast-pkts": "8649",
              "out-discards": "0",
              "out-errors": "0",
              "out-multicast-pkts": "184034",
              "out-octets": "23569377019",
              "out-unicast-pkts": "116336808"
            },
            "openconfig-interfaces:description": "",
            "openconfig-interfaces:enabled": true,
            "openconfig-interfaces:ifindex": 999001,
            "openconfig-interfaces:last-change": "171036192364",
            "openconfig-interfaces:mtu": 0,
            "openconfig-interfaces:name": "Management1",
            "openconfig-interfaces:oper-status": "UP",
            "openconfig-interfaces:type": "ethernetCsmacd"
          }
        }
      }
    ]
  }
]
```

eos_native test

```bash
root@mgmt:~# docker run --network host --rm ghcr.io/openconfig/gnmic get --log --username arista --password arista --insecure --address 172.22.1.250 --port 5900 --path 'eos_native:/Kernel/proc/cpu/utilization/total'
2024/06/26 19:30:55.348744 [gnmic] version=0.37.0, commit=05a3e785, date=2024-05-13T23:27:31Z, gitURL=https://github.com/openconfig/gnmic, docs=https://gnmic.openconfig.net
2024/06/26 19:30:55.348776 [gnmic] using config file ""
2024/06/26 19:30:55.348946 [gnmic] sending gNMI GetRequest: prefix='<nil>', path='[origin:"eos_native"  elem:{name:"Kernel"}  elem:{name:"proc"}  elem:{name:"cpu"}  elem:{name:"utilization"}  elem:{name:"total"}]', type='ALL', encoding='JSON', models='[]', extension='[]' to 172.22.1.250
2024/06/26 19:30:55.349361 [gnmic] creating gRPC client for target "172.22.1.250"
[
  {
    "source": "172.22.1.250",
    "timestamp": 1719427787116659585,
    "time": "2024-06-26T18:49:47.116659585Z",
    "prefix": "eos_native:Kernel/proc/cpu/utilization/total",
    "updates": [
      {
        "Path": "util",
        "values": {
          "util": 3
        }
      },
      {
        "Path": "iowait",
        "values": {
          "iowait": 389489
        }
      },
      {
        "Path": "irq",
        "values": {
          "irq": 2413338
        }
      },
      {
        "Path": "user",
        "values": {
          "user": 42695512
        }
      },
      {
        "Path": "softirq",
        "values": {
          "softirq": 1823319
        }
      },
      {
        "Path": "system",
        "values": {
          "system": 4697823
        }
      },
      {
        "Path": "name",
        "values": {
          "name": "total"
        }
      },
      {
        "Path": "nice",
        "values": {
          "nice": 135
        }
      },
      {
        "Path": "idle",
        "values": {
          "idle": 1258337973
        }
      }
    ]
  }
]
```
