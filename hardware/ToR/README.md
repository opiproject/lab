# Top of Rack

ToR switch/router provides network conectivity for management and access to the lab devices. All non test traffic goes through this device.

[Howto upgrade](https://www.arista.com/en/um-eos/eos-standard-upgrades-and-downgrades#prepare_the_switch_for_ssu)

## HW spec

- Part Number: Arista DCS-7280TR-48C6-R
- Hardware version: 11.04
- Software image version: 4.32.0F

```bash
tor>show vers
Arista DCS-7280TR-48C6-R
Hardware version: 11.04
Serial number: SSJ18302393
Hardware MAC address: 2899.3a9c.3965
System MAC address: 2899.3a9c.3965

Software image version: 4.32.0F
Architecture: i686
Internal build version: 4.32.0F-36401836.4320F
Internal build ID: 6217eea5-c8bc-4ca0-a5d9-7f4c1d4f8e78
Image format version: 3.0
Image optimization: Sand-4GB

Uptime: 1 week, 5 days, 6 hours and 33 minutes
Total memory: 8051592 kB
Free memory: 5897932 kB
```

## Management

- serial port
- 1G ethernet management port

## Docs

[Data Sheet](https://www.arista.com/assets/data/pdf/Datasheets/7280R-DataSheet.pdf)

## Pictures

![front](front.png)

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
tor>show management api gnmi
Octa: enabled

Transport: openmgmt
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
root@dh1:~# docker run --network host --rm ghcr.io/openconfig/gnmic get --log --username arista --password arista --insecure --address 172.22.0.5 --port 5900 --path /openconfig-interfaces:interfaces/interface[name=Management1]/state
2024/05/16 18:52:10.247944 [gnmic] version=0.37.0, commit=05a3e785, date=2024-05-13T23:27:31Z, gitURL=https://github.com/openconfig/gnmic, docs=https://gnmic.openconfig.net
2024/05/16 18:52:10.248005 [gnmic] using config file ""
2024/05/16 18:52:10.248420 [gnmic] sending gNMI GetRequest: prefix='<nil>', path='[elem:{name:"openconfig-interfaces:interfaces"}  elem:{name:"interface"  key:{key:"name"  value:"Management1"}}  elem:{name:"state"}]', type='ALL', encoding='JSON', models='[]', extension='[]' to 172.22.0.5
2024/05/16 18:52:10.249123 [gnmic] creating gRPC client for target "172.22.0.5"
[
  {
    "source": "172.22.0.5",
    "time": "1970-01-01T00:00:00Z",
    "updates": [
      {
        "Path": "interfaces/interface[name=Management1]/state",
        "values": {
          "interfaces/interface/state": {
            "arista-intf-augments:inactive": false,
            "openconfig-interfaces:admin-status": "UP",
            "openconfig-interfaces:counters": {
              "in-broadcast-pkts": "52578878",
              "in-discards": "0",
              "in-errors": "0",
              "in-multicast-pkts": "332586",
              "in-octets": "4134370723",
              "in-unicast-pkts": "5137160",
              "out-broadcast-pkts": "43",
              "out-discards": "0",
              "out-errors": "0",
              "out-multicast-pkts": "331867",
              "out-octets": "1259190372",
              "out-unicast-pkts": "5140141"
            },
            "openconfig-interfaces:description": "",
            "openconfig-interfaces:enabled": true,
            "openconfig-interfaces:ifindex": 999001,
            "openconfig-interfaces:last-change": "170595730184",
            "openconfig-interfaces:loopback-mode": false,
            "openconfig-interfaces:mtu": 0,
            "openconfig-interfaces:name": "Management1",
            "openconfig-interfaces:oper-status": "UP",
            "openconfig-interfaces:type": "iana-if-type:ethernetCsmacd",
            "openconfig-vlan:tpid": "openconfig-vlan-types:TPID_0X8100"
          }
        }
      }
    ]
  }
]
```

eos_native test

```bash
root@mgmt:~# docker run --network host --rm ghcr.io/openconfig/gnmic get --log --username arista --password arista --insecure --address 172.22.0.5 --port 5900 --path 'eos_native:/Kernel/proc/cpu/utilization/total'
2024/06/26 19:36:02.049760 [gnmic] version=0.37.0, commit=05a3e785, date=2024-05-13T23:27:31Z, gitURL=https://github.com/openconfig/gnmic, docs=https://gnmic.openconfig.net
2024/06/26 19:36:02.049805 [gnmic] using config file ""
2024/06/26 19:36:02.050010 [gnmic] sending gNMI GetRequest: prefix='<nil>', path='[origin:"eos_native"  elem:{name:"Kernel"}  elem:{name:"proc"}  elem:{name:"cpu"}  elem:{name:"utilization"}  elem:{name:"total"}]', type='ALL', encoding='JSON', models='[]', extension='[]' to 172.22.0.5
2024/06/26 19:36:02.050421 [gnmic] creating gRPC client for target "172.22.0.5"
[
  {
    "source": "172.22.0.5",
    "timestamp": 1719430186814981271,
    "time": "2024-06-26T19:29:46.814981271Z",
    "prefix": "eos_native:Kernel/proc/cpu/utilization/total",
    "updates": [
      {
        "Path": "idle",
        "values": {
          "idle": 624983782
        }
      },
      {
        "Path": "irq",
        "values": {
          "irq": 917291
        }
      },
      {
        "Path": "softirq",
        "values": {
          "softirq": 644250
        }
      },
      {
        "Path": "system",
        "values": {
          "system": 4889905
        }
      },
      {
        "Path": "util",
        "values": {
          "util": 4
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
          "nice": 268
        }
      },
      {
        "Path": "iowait",
        "values": {
          "iowait": 397063
        }
      },
      {
        "Path": "user",
        "values": {
          "user": 28358125
        }
      }
    ]
  }
]
```
