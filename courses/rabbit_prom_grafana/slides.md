---
# try also 'default' to start simple
theme: default
# random image from a curated Unsplash collection by Anthony
# like them? see https://unsplash.com/collections/94734566/slidev
# background: https://cover.sli.dev
# some information about your slides (markdown enabled)
title: Rabbit, Prometheus & Grafana
info: |
  Rabbit, Prometheus & Grafana
  Simion Ciprian Alin

# apply UnoCSS classes to the current slide
class: text-center
# https://sli.dev/features/drawing
drawings:
  persist: false
# slide transition: https://sli.dev/guide/animations.html#slide-transitions
transition: slide-left
# enable MDC Syntax: https://sli.dev/features/mdc
mdc: true
layout: intro
---

# Rabbit, Prometheus & Grafana

Simion Ciprian Alin


---
transition: slide-up
---


# Intro

- RabbitMQ - Message Broker
- Prometheus - Monitoring & Alerting
- Grafana - Visualization & Analytics


---
transition: slide-up

--- 

# Why?

- Distributed Systems
- Server performance monitoring and debugging
- Support for scalabale applications


---
transition: slide-up

---

# Rabbit Message Queue

- Producer 
- Exchange
- Queue
- Receiver (Consumer)


---
transition: slide-up

--- 

# RabbitMQ - Exchange

- 4 types of exchanges:
  - Direct
  - Topic
  - Headers
  - Fanout

- Binding 

---
transition: slide-up
layout: two-cols
--- 

# RabbitMQ - Exchange - Direct

- Routing Key
- Multiple bindings - fanout

  <Excalidraw
    drawFilePath="./rabbit_prom_grafana/assets/rabbit2.json"
    class="w-[400px]"
    :darkMode="true"
    :background="false"
  />

::right::
  <div class="flex flex-col items-center justify-center h-full">
  
  <Excalidraw
    drawFilePath="./rabbit_prom_grafana/assets/rabbit1.json"
    class="w-[400px]"
    :darkMode="true"
    :background="false"
  />
  </div>



---
transition: slide-up
layout: two-cols
--- 


# RabbitMQ - exchange topic

- Routing Key format - `word.word.word`
- Wildcards - `*` and `#` 
  - i.e. `*.orange.*` or `lazy.#`
- No wildcard -> exact match
- Binding key -> `#` -> fanout

::right::
<div class="flex flex-col items-center justify-center h-full">
  <Excalidraw
    drawFilePath="./rabbit_prom_grafana/assets/rabbit3.json"
    class="w-[400px]"
    :darkMode="true"
    :background="false"
  />
</div>

---
transition: slide-up
layout: two-cols
--- 

# RabbitMQ - RPC

- Callback queue
- Correlation ID

::right::
<div class="flex flex-col items-center justify-center -ml-60 h-full">
  <Excalidraw
    drawFilePath="./rabbit_prom_grafana/assets/rabbit4.json"
    class="w-[600px]"
    :darkMode="true"
    :background="false"
  />
</div>

---
transition: slide-up
--- 

# RabbitMQ - Streams

- Append only logs
- Consumer starts from first
- Retention policies
- Offset tracking


---
transition: slide-up
layout: intro
--- 

# Prometheus


---
transition: slide-up

--- 

# Prometheus

- OpenSource 
  - made by SoundCloud
- Main features
  - time-series database
  - data collection via exporters
  - alerting 

<!-- Prometheus is a system monitoring and alerting system. It was opensourced by SoundCloud in 2012 and is the second project both to join and to graduate within Cloud Native Computing Foundation after Kubernetes. Prometheus stores all metrics data as time series, i.e metrics information is stored along with the timestamp at which it was recorded, optional key-value pairs called as labels can also be stored along with metrics. -->


---
transition: slide-up

--- 

# Prometheus
<div class="flex flex-col items-center justify-center h-full">
<Excalidraw
  drawFilePath="./rabbit_prom_grafana/assets/prom1.json"
  class="w-[800px]"
  :darkMode="true"
  :background="false"
  />
</div>

---
transition: slide-up

---

# Prometheus - configuration

- `yaml` file
- `prometheus --config.file=prometheus.yml`
- http://localhost:9090



```yml {all|2|4|6|all}
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9419']

```

---
transition: slide-up

---

# Prometheus - metric types

- Counter
- Gauge
- Histogram
- Summary


---
transition: slide-up

---

# Prometheus - exporter example

```go {all|2|7-10|14|15|16|all}
var pingCounter = prometheus.NewCounter(
  prometheus.CounterOpts{
    Name: "ping_request_count",
    Help: "No of request handled by Ping handler",
  },
)

func ping(w http.ResponseWriter, r *http.Request) {
  pingCounter.Inc()
  w.Write([]byte("pong"))
}

func main() {
  prometheus.MustRegister(pingCounter)
  http.Handle("/metrics", promhttp.Handler())
  http.HandleFunc("/ping", ping)
  http.ListenAndServe(":9419", nil)
}

```

---
transition: slide-up
layout: iframe
url: http://localhost:9121/metrics
---

# Prometheus - exporter example

---
transition: slide-up

---

# Prometheus - Alert Manager 1

- Alerts based on rules computed on metrics
- Receivers
  - Email
  - Slack
  - Webhooks
  - etc.

---
transition: slide-up

---

# Prometheus - Alert Manager 2

- `alertmanager.yml`
- ` alertmanager --config.file=alertmanager.yml`
- http://localhost:9093


```yml {all|2|4|6|8|all}
global:
  resolve_timeout: 5m
route:
  receiver: webhook_receiver
receivers:
  - name: 'webhook_receiver'
    webhook_configs:
      - url: <INSERT_WEBHOOK_URL_HERE>
      send_resolved: false

```

---
transition: slide-up

---

# Prometheus - Alert Manager 3

- `rules.yml`


```yml {all|4|5|6|all}
groups:
  - name: Count grater than 5
    rules:
    - alert: CountGraterThan5
      expr: ping_request_count > 5
      for: 10s
```


---
transition: slide-up

---

# Prometheus - Alert Manager 4

- `prometheus.yml`


```yml {all|1-3|3|4-5|10|12-14|15-17|all}
global:
  scrape_interval: 15s
  evaluation_interval: 15s
rule_files:
  - "rules.yml"
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']
  - job_name: simple_server
    static_configs:
      - targets: ['localhost:8090']

```

---
transition: slide-up

---

# Prometheus - Push Gateway

- If one can't expose `/metrics` endpoint
- Push - replaces metrics sent with same labels
- Add

---
transition: slide-up
layout: intro
--- 

# Grafana


---
transition: slide-up

--- 

# Grafana

- Vizualization for data
- 150+ supported data sources 
  - (<span v-mark.red="1">Prometheus</span>, PostgreSQL, <span v-mark.circle.green="2">Mongo</span>, Loki, <span v-mark.circle.blue="3">ElasticSearch</span>, MySQL , InfluxDB, etc.)
- Dashboards & Alerts
- Panels - query + visualization
- Transformations


---
transition: slide-up

--- 

# Documentation

- RabbitMQ - https://www.rabbitmq.com/docs
- Prometheus - https://prometheus.io/docs/introduction/overview/
- Grafana - https://grafana.com/docs/


---
transition: slide-up
layout: end
--- 

# Thank you! 
## Q&A

