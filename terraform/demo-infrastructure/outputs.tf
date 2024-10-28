output "resource-ids" {
  value = <<-EOT

  ====

  ${title(module.demo_environment.confluent_environment.display_name)} Environment ID:   ${module.demo_environment.id}
  ${title(module.demo_environment.confluent_environment.display_name)} Schema Registry ID:   ${module.demo_environment.schema_registry_cluster.id}
  ${title(module.demo_environment.confluent_environment.display_name)} Schema Registry Rest Endpoint:   ${module.demo_environment.schema_registry_cluster.rest_endpoint}
  ${title(module.demo_environment.confluent_environment.display_name)} EnvironmentAdmin/AccountAdmin API Key:  ${module.demo_environment.cluster_admin_api_key.id}:${module.demo_environment.cluster_admin_api_key.secret}

  ${title(module.demo_environment.confluent_kafka_cluster.display_name)} Cluster ID: ${module.demo_environment.id}
  ${title(module.demo_environment.confluent_kafka_cluster.display_name)} Flink Compute Pool ID: ${module.demo_environment.flink_compute_pool_id}
  ${title(module.demo_environment.confluent_kafka_cluster.display_name)} Cluster Admin: "${module.demo_environment.cluster_admin_api_key.id}:${module.demo_environment.cluster_admin_api_key.secret}"

  **************
  Client Configs
  **************

  "bootstrap.servers": "${module.demo_environment.confluent_kafka_cluster.bootstrap_endpoint}",

  # sasl jaas config
  "sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username='${module.demo_environment.cluster_admin_api_key.id}' password='${module.demo_environment.cluster_admin_api_key.secret}';",

  # schema registry
  "schema.registry.url": "${module.demo_environment.schema_registry_cluster.rest_endpoint}",
  "basic.auth.credentials.source": "USER_INFO",
  "basic.auth.user.info": "${module.demo_environment.data_steward_api_key.id}:${module.demo_environment.data_steward_api_key.secret}",

  **************
  **************

  Getting Started with Flink:

  > confluent flink shell --compute-pool ${module.demo_environment.flink_compute_pool_id} --environment ${module.demo_environment.id}

  EOT

  sensitive = true
}
