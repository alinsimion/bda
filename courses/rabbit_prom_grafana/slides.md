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

<!--
What is RabbitMQ?
RabbitMQ is an open-source message broker software (sometimes called message-oriented middleware) that implements the Advanced Message Queuing Protocol (AMQP). It acts as an intermediary for messaging between applications, allowing them to communicate and exchange data asynchronously.

What is Prometheus?
Prometheus is an open-source monitoring and alerting toolkit designed for reliability and scalability. It is widely used for monitoring applications, services, and infrastructure in cloud-native environments. Prometheus collects and stores time-series data, allowing users to query and visualize metrics in real-time.

What is Grafana?
Grafana is an open-source analytics and monitoring platform that allows users to visualize and analyze data from various sources, including databases, cloud services, and monitoring tools like Prometheus. It provides a flexible and customisable dashboard interface for creating interactive visualizations and alerts.
-->

---
transition: slide-up

--- 

# Why?

- Distributed Systems
- Server performance monitoring and debugging
- Support for scalabale applications

<!-- 
Why RabbitMQ?
RabbitMQ is used to facilitate communication between different components of a distributed system. It helps decouple applications, allowing them to communicate asynchronously and improving overall system reliability and scalability.

Why Prometheus?
Prometheus is used for monitoring and alerting in modern cloud-native environments. It provides a powerful and flexible way to collect, store, and query metrics data, enabling users to gain insights into the performance and health of their applications and infrastructure.

We can also use it to hold time-series data for analysis.

Why Grafana?
Grafana is used to visualize and analyze data from various sources, making it easier for users to understand complex datasets. It provides a user-friendly interface for creating interactive dashboards and alerts, helping users monitor their systems effectively.



-->


---
transition: slide-up

---

# Rabbit Message Queue

- Producer 
- Exchange
- Queue
- Receiver (Consumer)

<!-- The main components of RabbitMQ include producers, exchanges, queues, and consumers.
- Producers are applications that send messages to RabbitMQ.
- Exchanges are responsible for routing messages to the appropriate queues based on predefined rules.
- Queues are where messages are stored until they are consumed by a consumer.
- Consumers are applications that receive and process messages from RabbitMQ.
-->


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

<!-- Exchanges are responsible for routing messages to the appropriate queues based on predefined rules. There are four main types of exchanges in RabbitMQ:
- Direct Exchange: Routes messages to queues based on an exact match between the routing key and the binding key.
- Topic Exchange: Routes messages to queues based on pattern matching between the routing key and the binding key, allowing for more flexible routing.
- Headers Exchange: Routes messages based on message headers rather than the routing key.
- Fanout Exchange: Broadcasts messages to all bound queues, regardless of the routing key.

Binding is the process of associating a queue with an exchange, allowing messages to be routed to the appropriate queue based on the exchange type and routing rules.
-->

---
transition: slide-up
layout: two-cols
--- 

# RabbitMQ - Exchange - Direct

- Routing Key
- Multiple bindings - fanout
<br/>
<br/>
<br/>
<!-- drawFilePath="./diagrams/rabbit1.json" -->
<Excalidraw
  drawFilePath="./diagrams/rabbit1.json"
  class="w-[400px]"
  :darkMode="true"
  :background="false"
/>

::right::
<div class="flex flex-col items-center justify-center h-full">
  <Excalidraw
    drawFilePath="./diagrams/rabbit2.json"
    class="w-[400px]"
    :darkMode="true"
    :background="false"
  />
</div>

<!-- 
Routing Key: A routing key is a string that is used to determine how messages are routed from an exchange to a queue. In a direct exchange, the routing key must match the binding key of the queue for the message to be delivered.

Multiple bindings: A queue can be bound to multiple exchanges, allowing it to receive messages from different sources. This is often used in a fanout exchange, where messages are broadcast to all bound queues regardless of the routing key.

-->


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
    drawFilePath="./diagrams/rabbit3.json"
    class="w-[400px]"
    :darkMode="true"
    :background="false"
  />
</div>


<!--
Routing Key format: In a topic exchange, the routing key is a string that consists of words separated by dots (e.g., "word.word.word"). This format allows for more flexible routing based on patterns.

Wildcards: Topic exchanges support two types of wildcards in routing keys:
- Asterisk (*): Matches exactly one word in the routing key.
- Hash (#): Matches zero or more words in the routing key.

No wildcard -> exact match: If a routing key does not contain any wildcards, it must match the binding key of the queue exactly for the message to be delivered.

Binding key -> # -> fanout: If a queue is bound to a topic exchange with a binding key of "#", it will receive all messages sent to that exchange, effectively acting like a fanout exchange.

-->

---
transition: slide-up
layout: two-cols
--- 

# RabbitMQ - RPC pattern

- Callback queue
- Correlation ID

::right::
<div class="flex flex-col items-center justify-center -ml-60 h-full">
  <Excalidraw
    drawFilePath="./diagrams/rabbit4.json"
    class="w-[600px]"
    :darkMode="true"
    :background="false"
  />
</div>

<!-- 

Callback queue: In an RPC (Remote Procedure Call) pattern using RabbitMQ, a callback queue is a temporary queue created by the client to receive responses from the server. The client sends a request message to the server and includes the name of the callback queue in the message properties. The server processes the request and sends the response back to the specified callback queue.

Correlation ID: A correlation ID is a unique identifier included in the message properties to correlate requests and responses in an RPC pattern. When the client sends a request, it generates a unique correlation ID and includes it in the message. When the server sends the response back to the callback queue, it includes the same correlation ID in the response message. The client can then use this correlation ID to match the response with the original request.

-->


---
transition: slide-up
--- 

# RabbitMQ - Streams

- Append only logs
- Consumer starts from first
- Retention policies
- Offset tracking

<!-- 
Append only logs: RabbitMQ Streams are designed to store messages in an append-only log format, allowing for efficient storage and retrieval of messages.

Consumer starts from first: When a consumer subscribes to a RabbitMQ Stream, it can start consuming messages from the beginning of the stream, allowing it to process all messages in the order they were added.

Retention policies: RabbitMQ Streams support configurable retention policies, allowing users to define how long messages should be retained in the stream before being deleted. This helps manage storage space and ensures that only relevant messages are kept.

Offset tracking: RabbitMQ Streams provide offset tracking capabilities, allowing consumers to keep track of their position in the stream. This enables consumers to resume processing from where they left off in case of failures or restarts.

-->


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
  drawFilePath="./diagrams/prom1.json"
  class="w-[800px]"
  :darkMode="true"
  :background="false"
  />
</div>

<!-- 
How Prometheus works:
1. Data Collection: Prometheus collects metrics data from various sources using exporters. Exporters are applications that expose metrics in a format that Prometheus can scrape. 

2. Data Storage: Prometheus stores the collected metrics data in a time-series database. Each metric is stored along with a timestamp and optional labels that provide additional context about the metric.

3. Data Querying: Prometheus provides a powerful query language called PromQL that allows users to query and analyze the stored metrics data. Users can create complex queries to extract insights and visualize the data.

4. Alerting: Prometheus includes an alerting system that allows users to define alerting rules based on the collected metrics data. When certain conditions are met, Prometheus can send alerts to various notification channels, such as email, Slack, or PagerDuty.

-->

---
transition: slide-up

---

# Prometheus - configuration

- `yaml` file
- `prometheus --config.file=prometheus.yml`
- http://localhost:9090



```yml {2|4|6|all}
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9419']

```

<!--

This configuration file sets the global scrape interval to 15 seconds, meaning Prometheus will collect metrics from the specified targets every 15 seconds. The scrape_configs section defines a job named "prometheus" that targets the localhost on port 9419, where an exporter is expected to expose metrics.

-->

---
transition: slide-up

---

# Prometheus - metric types

- Counter
- Gauge
- Histogram
- Summary

<!--
Prometheus supports four main types of metrics:
1. Counter: A counter is a cumulative metric that represents a single monotonically increasing value. It is typically used to count events, such as the number of requests received or errors encountered.
2. Gauge: A gauge is a metric that represents a single numerical value that can go up or down. It is typically used to measure values that can fluctuate, such as temperature, memory usage, or the number of active connections.
3. Histogram: A histogram is a metric that samples observations and counts them in configurable buckets. It is typically used to measure the distribution of values, such as request latencies or response sizes.
4. Summary: A summary is similar to a histogram but provides quantile estimates over a sliding time window. It is typically used to measure the distribution of values and provides more detailed information about the data.

-->

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

<!-- 
 This Golang program sets up a simple HTTP server that exposes two endpoints: /ping and /metrics. The /ping endpoint increments a Prometheus counter metric named ping_request_count each time it is accessed, while the /metrics endpoint exposes the metrics in a format that Prometheus can scrape.
-->

---
transition: slide-up
layout: iframe-right
url: http://localhost:9419/metrics
---

# Prometheus - exporter example

<RequestButton url="http://localhost:9419/ping" method="GET" class="mb-4" label="Send Ping Request">
</RequestButton>


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

<!-- 

Prometheus Alertmanager is a component of the Prometheus monitoring system that handles alerts generated by Prometheus server. It is responsible for managing and routing alerts to various notification channels, such as email, Slack, webhooks, and more. Alertmanager allows users to define alerting rules based on the metrics collected by Prometheus and provides features such as grouping, inhibition, and silencing of alerts to reduce noise and improve alert management.

-->


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

<!-- 

This configuration file sets up a Prometheus Alertmanager instance with a single receiver that sends alerts to a specified webhook URL. The global section defines a resolve timeout of 5 minutes, which determines how long an alert remains active after it has been resolved. The route section specifies that all alerts should be sent to the webhook_receiver. The receivers section defines the webhook_receiver, which is configured to send alerts to the specified webhook URL and not send resolved alerts.

-->

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

<!--
This configuration file defines an alerting rule for Prometheus. The rule is part of a group named "Count greater than 5" and specifies a single alert called "CountGraterThan5". The alert is triggered when the expression ping_request_count > 5 evaluates to true for a duration of 10 seconds. This means that if the ping_request_count metric exceeds 5 for at least 10 seconds, the alert will be fired.
-->


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

<!-- 

This configuration file sets up a Prometheus server with alerting capabilities. The global section defines the scrape interval and evaluation interval, both set to 15 seconds. The rule_files section specifies that the alerting rules are defined in the rules.yml file. The alerting section configures Prometheus to send alerts to an Alertmanager instance running on localhost at port 9093. The scrape_configs section defines two jobs: one for scraping metrics from the Prometheus server itself (localhost:9090) and another for scraping metrics from a simple server running on localhost at port 8090.

-->

---
transition: slide-up

---

# Prometheus - Push Gateway

- If one can't expose `/metrics` endpoint
- Push - replaces metrics sent with same labels
- Add


<Excalidraw
  drawFilePath="./diagrams/prom2.json"
  class="w-[800px]"
  :darkMode="true"
  :background="false"
  />


<!-- 

 In some scenarios, applications may not be able to expose a /metrics endpoint for Prometheus to scrape. This can happen in cases where the application is short-lived, runs in an environment without network access, or has other constraints that prevent it from exposing metrics.

-->

---
transition: slide-up
layout: intro
--- 

# Grafana

<!-- Grafana is an open-source analytics and monitoring platform that allows users to visualize and analyze data from various sources, including databases, cloud services, and monitoring tools like Prometheus. It provides a flexible and customizable dashboard interface for creating interactive visualizations and alerts. -->

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

<!-- 
Grafana is primarily used for visualizing time-series data, but it also supports other types of data. It provides a wide range of visualization options, including graphs, tables, heatmaps, and more. Grafana allows users to create custom dashboards by combining multiple visualizations into a single view. Users can also set up alerts based on specific conditions, such as threshold breaches or changes in data patterns. 

Some of the supported data sources include Prometheus, PostgreSQL, MongoDB, Elasticsearch, and many others.

Panels in Grafana are individual visualizations that can be added to a dashboard. Each panel consists of a query that retrieves data from a data source and a visualization that displays the data in a specific format.

Transformations in Grafana allow users to manipulate and modify data before it is visualized. This includes operations such as filtering, aggregating, and joining data from multiple sources.

-->

---
transition: slide-up

--- 

# Documentation

- RabbitMQ - https://www.rabbitmq.com/docs
- Prometheus - https://prometheus.io/docs/introduction/overview/
- Grafana - https://grafana.com/docs/

<!--
For more detailed information and documentation on RabbitMQ, Prometheus, and Grafana, you can visit the following official documentation links:
- RabbitMQ Documentation: https://www.rabbitmq.com/docs
- Prometheus Documentation: https://prometheus.io/docs/introduction/overview/
- Grafana Documentation: https://grafana.com/docs/
-->


---
transition: slide-up
layout: end
--- 

# Thank you! 
## Q&A
