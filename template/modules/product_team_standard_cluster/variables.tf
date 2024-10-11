variable "cluster_display_name" {
  description = "The name of the Confluent Cloud Cluster to create"
  type        = string
}

variable "environment_id" {
  description = "The ID of the environment to create the cluster within"
  type        = string
}

variable "enable_flink_workspace" {
  description = "Flag that drives the creation of a Flink Workspace for the cluster in the target environment"
  type        = bool
  default     = false
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

variable "cloud_availability" {
  description = "The availability of the cluster within the cloud provider"
  type        = string
  default     = "SINGLE_ZONE"

  validation {
    condition     = contains(["SINGLE_ZONE"], var.cloud_availability)
    error_message = "The cloud_availability must be 'SINGLE_ZONE' at this time."
  }
}

variable "cloud_region" {
  description = "The region in the selected cloud"
  type        = string
  default     = "us-east1"

  validation {
    condition     = contains(["us-east1"], var.cloud_region)
    error_message = "The cloud_region must be 'us-east1' at this time - Flink availability is the limiter (https://docs.confluent.io/cloud/current/flink/overview.html#af-long-is-everywhere)"
  }
}
