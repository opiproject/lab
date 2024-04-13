# Monitoring & Telemetry

Took from <https://github.com/opiproject/otel>

## On DPUs and IPUs

1. Create `telegraf.conf` file, see example [here](./config/telegraf.conf)
2. Run telegraf container:

```bash
$ sudo docker run --rm -it --network=host -v ./config/telegraf.conf:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.29
```

## On Management server

Run `docker compose up -d` or `docker-compose up -d`

:exclamation: `docker-compose` is deprecated. For details, see [Migrate to Compose V2](https://docs.docker.com/compose/migrate/).

This will start those services:

1. [OTEL Gateway Collector](https://opentelemetry.io/docs/collector/deployment/gateway/) to aggregate telemetry from all DPUs and IPUs.
2. [Prometheus](https://prometheus.io/) Monitoring system & time series database

To query Prometheus:

1. Open http://localhost:9091 to explore UI
2. or via API examples:

```bash
curl --fail http://127.0.0.1:9091/api/v1/query?query=mem_free | grep mem_free
curl --fail http://127.0.0.1:9091/api/v1/query?query=cpu_usage_user | grep cpu_usage_user
curl --fail http://127.0.0.1:9091/api/v1/query?query=dpu_num_blocks | grep dpu_num_blocks
curl --fail http://127.0.0.1:9091/api/v1/query?query=net_bytes_recv_total | grep net_bytes_recv_total
curl --fail http://127.0.0.1:9091/api/v1/query?query=nginx_requests | grep nginx_requests
curl --fail http://127.0.0.1:9091/api/v1/query?query=redfish_thermal_fans_reading_rpm | grep redfish_thermal_fans_reading_rpm
```
