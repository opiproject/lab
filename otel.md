# Monitoring & Telemetry

Took from <https://github.com/opiproject/otel>

![OPI Telemetry Deploy Option](https://github.com/opiproject/otel/blob/main/doc/dpu-otel.png)

## Standartization

OPI standardized on OTEL, but is agnostic to actual collector or agent implementation that each vendor decides to run inside.

For example, Nvidia is using [Nvidia Doca Telemetry Service](https://docs.nvidia.com/doca/sdk/nvidia+doca+telemetry+service+guide/index.html), unfortanutely it does not support OTEL as of writing this paragraph.

## On DPUs and IPUs

### Configuration

Create `telegraf.conf` file, see example [here](./telegraf.d/telegraf.conf.bf2)

- change `172.22.0.1` in `outputs.opentelemetry` to the correct management server name/ip
- change `192.168.240.1` and credentails to the internal DPU/IPU AMC/BMC for redfish collection

### Service

Run telegraf container:

```bash
sudo docker run -d --restart=always --network=host -v ./telegraf.d/telegraf.conf.bf2:/etc/telegraf/telegraf.conf docker.io/library/telegraf:1.31
```

### Optional SPDK

To monitor [SPDK](https://spdk.io/) storage metrics, make sure correct service is running:

```bash
systemctl stop mlnx_snap
systemctl start spdk_tgt
```

And few block devices exist to monitor, like:

```bash
spdk_rpc.py bdev_malloc_create -b Malloc0 64 512
spdk_rpc.py bdev_malloc_create -b Malloc1 64 512
```

And [Proxy](https://github.com/spdk/spdk/blob/v24.01.x/scripts/rpc_http_proxy.py) script is running:

```bash
# TODO: make it a service
spdk_rpc_http_proxy.py 0.0.0.0 9009 spdkuser spdkpass
```

And add this to your config file:

```ini
[[inputs.http]]
  urls = ["http://localhost:9009"]
  headers = {"Content-Type" = "application/json"}
  method = "POST"
  username = "spdkuser"
  password = "spdkpass"
  body = '{"id":1, "method": "bdev_get_iostat"}'
  data_format = "json"
  name_override = "spdk"
  json_strict = true
  tag_keys = ["name"]
  json_query = "result.bdevs"
```

### Optional Temperature

For regular Servers, add to your config file:

```ini
[[inputs.temp]]
  # no configuration
```

For `Nvidia BlueField` cards, to monitor temperature, add to your telegraf config file:

```ini
[[inputs.file]]
  files = ["/run/emu_param/bluefield_temp"]
  name_override = "temp"
  value_field_name="temp"
  data_format = "value"
  data_type = "integer"
  file_tag = "sensor"
```

and add to your docker run command:

```text
-v /run/emu_param:/run/emu_param
```

and make sure emulation service is running:

```bash
systemctl start set_emu_param
```

For `Intel MEV` cards the temperature is on the ICC chip, no easy access to it:

```ini
[[inputs.exec]]
  commands = ["iset-cli get-temperature"]
  name_override = "temp"
  data_format = "json"
```

## On Management server

See management server details [here](../hardware/mgmt)

### Run

Run `docker compose up -d` or `docker-compose up -d`

:exclamation: `docker-compose` is deprecated. For details, see [Migrate to Compose V2](https://docs.docker.com/compose/migrate/).

This will start those services:

1. [OTEL Gateway Collector](https://opentelemetry.io/docs/collector/deployment/gateway/) to aggregate telemetry from all DPUs and IPUs.
2. [Prometheus](https://prometheus.io/) Monitoring system & time series database
3. [Grafana](https://grafana.com/) Open source analytics & monitoring solution for every database.

### Otel Gateway Collector

1. <http://172.22.0.1:13133> - health check
2. <http://172.22.0.1:8888/metrics> - my own metrics
3. <http://172.22.0.1:8889/metrics> - real metrics

### Prometheus

1. Open <http://172.22.0.1:9091> to explore Prometheus UI
2. or via API examples:

```bash
curl --fail http://172.22.0.1:9091/api/v1/query?query=mem_free | grep mem_free
curl --fail http://172.22.0.1:9091/api/v1/query?query=cpu_usage_user | grep cpu_usage_user
curl --fail http://172.22.0.1:9091/api/v1/query?query=spdk_num_read_ops | grep spdk_num_read_ops
curl --fail http://172.22.0.1:9091/api/v1/query?query=nstat_TcpActiveOpens | grep nstat_TcpActiveOpens
curl --fail http://172.22.0.1:9091/api/v1/query?query=redfish_power_powercontrol_interval_in_min | grep redfish_power_powercontrol_interval_in_min
```

### Grafana

1. Open <http://172.22.0.1:3000> to explore Grafana UI
2. or via API examples:

```bash
curl -s http://172.22.0.1:3000/api/datasources | jq .
```
