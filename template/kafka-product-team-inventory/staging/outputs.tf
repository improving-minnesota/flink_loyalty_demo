output "shadowtraffic-config" {
  value = <<-EOT

  # Replace the value in `/shadowtraffic/orders/config/connections/staging-kafka.json` with the value below

  {
    "bootstrap.servers": "${module.inventory_cluster.confluent_kafka_cluster.bootstrap_endpoint}",
    "sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username='${module.inventory_cluster.developer_write_api_key.id}' password='${module.inventory_cluster.developer_write_api_key.secret}';",
    "schema.registry.url": "${data.confluent_schema_registry_cluster.this.rest_endpoint}",
    "basic.auth.user.info": "${module.inventory_cluster.data_steward_api_key.id}:${module.inventory_cluster.data_steward_api_key.secret}",

    "key.serializer": "org.apache.kafka.common.serialization.StringSerializer",
    "value.serializer": "io.confluent.kafka.serializers.KafkaAvroSerializer",
    "basic.auth.credentials.source": "USER_INFO",
    "sasl.mechanism": "PLAIN",
    "security.protocol": "SASL_SSL",
    "client.dns.lookup": "use_all_dns_ips"
  }
  EOT

  sensitive = true
}

output "resource-ids" {
  value = <<-EOT
  '${data.confluent_environment.this.display_name}' Environment ID: ${data.confluent_environment.this.id}
  '${module.inventory_cluster.confluent_kafka_cluster.display_name}' Cluster ID: ${module.inventory_cluster.id}
  '${module.inventory_cluster.confluent_kafka_cluster.display_name}' Flink Compute Pool ID: ${module.inventory_cluster.flink_compute_pool_id}
  '${module.inventory_cluster.confluent_kafka_cluster.display_name}' Cluster Admin: "${module.inventory_cluster.cluster_admin_api_key.id}:${module.inventory_cluster.cluster_admin_api_key.secret}"

  ****************************
  Metrics Scrape Job Configs
  ****************************
  Flink Scrape Job URL:   https://api.telemetry.confluent.cloud/v2/metrics/cloud/export?resource.compute_pool.id=${module.inventory_cluster.flink_compute_pool_id}
  Cluster Scrape Job URL: https://api.telemetry.confluent.cloud/v2/metrics/cloud/export?resource.kafka.id=${module.inventory_cluster.id}

  Metrics API Username/Password - RUN `/kafka-ops-team > terraform output staging-resource-ids`

  **************
  Client Configs
  **************

  "bootstrap.servers": "${module.inventory_cluster.confluent_kafka_cluster.bootstrap_endpoint}",

  # '${module.inventory_cluster.developer_write_service_account.display_name}' sasl jaas config
  "sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username='${module.inventory_cluster.developer_write_api_key.id}' password='${module.inventory_cluster.developer_write_api_key.secret}';",

  # '${module.inventory_cluster.developer_read_service_account.display_name}' sasl jaas config
  "sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username='${module.inventory_cluster.developer_read_api_key.id}' password='${module.inventory_cluster.developer_read_api_key.secret}';",

  # schema registry
  "schema.registry.url": "${data.confluent_schema_registry_cluster.this.rest_endpoint}",
  "basic.auth.credentials.source": "USER_INFO",
  "basic.auth.user.info": "${module.inventory_cluster.data_steward_api_key.id}:${module.inventory_cluster.data_steward_api_key.secret}",

  **************
  **************

  Getting Started with Flink:

  > confluent flink shell --compute-pool ${module.inventory_cluster.flink_compute_pool_id} --environment ${data.confluent_environment.this.id}

  EOT

  sensitive = true
}
