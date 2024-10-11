output "id" {
  description = "ID of the Confluent Kafka Cluster that was created within the provided environment."
  value       = confluent_kafka_cluster.this.id
}

output "confluent_kafka_cluster" {
  description = "Confluent Kafka Cluster that was created within the provided environment."
  value       = confluent_kafka_cluster.this
}

output "schema_registry_cluster" {
  description = "The full Confluent Schema Registry Cluster resource that was created."
  value       = data.confluent_schema_registry_cluster.this
}

output "cluster_admin_service_account" {
  description = "Service Account to manage the provisioned Kafka cluster."
  value       = confluent_service_account.cluster-admin
}

output "cluster_admin_api_key" {
  description = "Kafka API Key with 'CloudClusterAdmin' access that is owned by the cluster_admin_service_account"
  value       = confluent_api_key.cluster-admin-kafka-api-key
}

output "data_steward_api_key" {
  description = "API Key with 'DataSteward' access that is owned by the env_admin_service_account"
  value       = confluent_api_key.env-admin-data-steward-api-key
}

output "flink_admin_service_account" {
  description = "Service Account to manage the Flink Resources."
  value       = var.enable_flink_workspace ? confluent_service_account.cluster-flink-admin[0] : null
}

output "flink_admin_api_key" {
  description = "API Key with 'FlinkAdmin' access that is owned by the flink_admin_service_account"
  value       = var.enable_flink_workspace ? confluent_api_key.cluster-flink-admin-api-key[0] : null
}

output "developer_write_service_account" {
  description = "Default DeveloperWrite Service Account for the Cluster"
  value       = confluent_service_account.cluster-developer-write
}

output "developer_write_api_key" {
  description = "API Key with 'DeveloperWrite' access that is owned by the developer_write_service_account"
  value       = confluent_api_key.cluster-developer-write-kafka-api-key
}

output "developer_read_service_account" {
  description = "Default DeveloperRead Service Account for the Cluster"
  value       = confluent_service_account.cluster-developer-read
}

output "developer_read_api_key" {
  description = "API Key with 'DeveloperRead' access that is owned by the developer_read_service_account"
  value       = confluent_api_key.cluster-developer-read-kafka-api-key
}

output "flink_compute_pool_id" {
  description = "Flink Compute Pool"
  value       = var.enable_flink_workspace ? confluent_flink_compute_pool.main[0].id : ""
}

output "flink_rest_endpoint" {
  description = "Flink Rest Endpoint"
  value       = var.enable_flink_workspace ? data.confluent_flink_region.this[0].rest_endpoint : ""
}