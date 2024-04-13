# Management server

as of now this is merged with dh1 until new server arives

## Roles

- DHCP server for the lab
- GitHub self hosted runners
- OTEL, Prometheus and Grafana servers for the lab monitoring
- SZTP bootstrap server for the lab
- network gateway between private network 172.22 and the internet
- Other containers and vms for remaining services

## BIOS settings

- change power to always on

## DHCP server

run bare metal or via docker:

```bash
sudo docker run --rm -it --network=host --privileged --restart always -v "$(PWD)"/fs/etc/dhcp/dhcpd.conf:/etc/dhcp/dhcpd.conf docker.io/networkboot/dhcpd:1.3.0
```

or [compose](https://github.com/opiproject/sztp/blob/0addb57154332e7ecdebe4ba18b2633278857ef5/docker-compose.yml#L51-L68)
