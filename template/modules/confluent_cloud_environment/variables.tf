variable "stream_governance_package" {
  description = "The selected stream governance package - more details can be found at https://docs.confluent.io/cloud/current/stream-governance/packages.html#governance-package-types"
  type        = string
  default     = "ESSENTIALS"

  validation {
    condition     = contains(["ESSENTIALS", "ADVANCED"], var.stream_governance_package)
    error_message = "The stream_governance_package must be either 'ESSENTIALS' or 'ADVANCED'."
  }
}

variable "environment_display_name" {
  description = "Confluent Cloud Environment Display Name"
  type        = string
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
    error_message = "The cloud_provider must be 'us-east1' at this time."
  }
}