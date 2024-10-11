variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID) with EnvironmentAdmin permissions provided by Kafka Ops team"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "cloud_provider" {
  description = "The selected cloud provider"
  type        = string
  default     = "GCP"

  validation {
    condition     = contains(["GCP"], var.cloud_provider)
    error_message = "The cloud_provider must be 'GCP' at this time."
  }
}

variable "cloud_region" {
  description = "The region in the selected cloud"
  type        = string
  default     = "us-east1"

  validation {
    condition     = contains(["us-east1"], var.cloud_region)
    error_message = "The cloud_region must be 'us-east1' at this time - Flink availability is the limiter (https://docs.confluent.io/cloud/current/flink/overview.html#af-long-is-everywhere)."
  }
}