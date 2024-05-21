# DPU Host 1

Dell PowerEdge R650

## BIOS settings

- change power to always on

## Otel or telegraf

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.29
```
