# DPU Host 4

Dell PowerEdge R760

## BIOS settings

- change power to always on

## IPU

Intel Dayton Peak

* to enable port forwarding for `OTEL` from `ACC` through `IMC`, run:

```bash
dnf install -y socat
socat tcp-l:4317,fork,reuseaddr tcp:172.22.0.1:4317
```
