output "resource-ids" {
  value = <<-EOT

  ====

  ${title(module.demo_environment.confluent_environment.display_name)} Environment ID:   ${module.demo_environment.id}
  ${title(module.demo_environment.confluent_kafka_cluster.display_name)} Cluster ID: ${module.demo_environment.id}
  ${title(module.demo_environment.confluent_environment.display_name)} Schema Registry ID:   ${module.demo_environment.schema_registry_cluster.id}
  ${title(module.demo_environment.confluent_kafka_cluster.display_name)} Flink Compute Pool ID: ${module.demo_environment.flink_compute_pool_id}

  **************
  Client Configs
  **************

  "bootstrap-servers": "${module.demo_environment.confluent_kafka_cluster.bootstrap_endpoint}"
  "api-key-id":  "${module.demo_environment.cluster_admin_api_key.id}"
  "api-key-secret": "${module.demo_environment.cluster_admin_api_key.secret}"

  "schema-reg-url": "${module.demo_environment.schema_registry_cluster.rest_endpoint}"
  "schema-reg-api-key-id": "${module.demo_environment.data_steward_api_key.id}"
  "schema-reg-api-key-secret": "${module.demo_environment.data_steward_api_key.secret}"


  **************
  FLINK SHELL
  **************

  > confluent flink shell --compute-pool ${module.demo_environment.flink_compute_pool_id} --environment ${module.demo_environment.id}

  **************  **************  **************  **************  **************  **************
  PRODUCT PRODUCER SETTINGS
  Paste this line to set all the ENV variables to run the product producer.
  **************  **************  **************  **************  **************  **************

  export DEMO_CLUSTER_BOOTSTRAP=${trimprefix(module.demo_environment.confluent_kafka_cluster.bootstrap_endpoint, "SASL_SSL://")}; export PRODUCT_API_KEY_ID=${module.demo_environment.cluster_admin_api_key.id};export PRODUCT_API_KEY_SECRET=${module.demo_environment.cluster_admin_api_key.secret}


  EOT

  sensitive = true
}
