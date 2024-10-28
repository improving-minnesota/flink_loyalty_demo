output "id" {
  description = "ID of the Confluent Cloud Environment that was created."
  value       = confluent_environment.this.id
}

output "confluent_environment" {
  description = "The full Confluent Environment resource that was created."
  value       = confluent_environment.this
}

output "schema_registry_cluster" {
  description = "The full Confluent Schema Registry Cluster resource that was created."
  value       = data.confluent_schema_registry_cluster.this
}

output "cluster_id" {
  description = "ID of the Confluent Kafka Cluster that was created within the provided environment."
  value       = confluent_kafka_cluster.this.id
}

output "confluent_kafka_cluster" {
  description = "Confluent Kafka Cluster that was created within the provided environment."
  value       = confluent_kafka_cluster.this
}

output "flink_compute_pool_id" {
  description = "Flink Compute Pool"
  value       = confluent_flink_compute_pool.main.id
}

output "flink_rest_endpoint" {
  description = "Flink Rest Endpoint"
  value       = data.confluent_flink_region.this.rest_endpoint
}

// API Keys

output "cluster_admin_api_key" {
  description = "Kafka API Key with 'EnvironmentAdmin' access that is owned by the env_admin_service_account"
  value       = confluent_api_key.cluster-admin-api-key
}

output "data_steward_api_key" {
  description = "API Key with 'DataSteward' access that is owned by the env_admin_service_account"
  value       = confluent_api_key.data-steward-api-key
}

output "flink_admin_api_key" {
  description = "API Key with 'FlinkAdmin' access that is owned by the flink_admin_service_account"
  value       = confluent_api_key.flink-admin-api-key
}

