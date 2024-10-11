output "id" {
  description = "ID of the Confluent Cloud Environment that was created."
  value       = confluent_environment.this.id
}

output "confluent_environment" {
  description = "The full Confluent Environment resource that was created."
  value       = confluent_environment.this
}

output "env_admin_service_account" {
  description = "Service Account to manage the provisioned environment."
  value       = confluent_service_account.env-admin
}

output "env_admin_api_key" {
  description = "Kafka API Key with 'EnvironmentAdmin' access that is owned by the env_admin_service_account"
  value       = confluent_api_key.env-admin-cloud-api-key
}

output "env_metrics_viewer_api_key" {
  description = "Kafka API Key with 'MetricsViewer' access that is owned by the env_metrics_viewer_service_account"
  value       = confluent_api_key.env_metrics_viewer_api_key
}
