variable "stream_governance_package" {
  description = "The selected stream governance package - more details can be found at https://docs.confluent.io/cloud/current/stream-governance/packages.html#governance-package-types"
  type        = string
  default     = "ESSENTIALS"

  validation {
    condition     = contains(["ESSENTIALS", "ADVANCED"], var.stream_governance_package)
    error_message = "The stream_governance_package must be either 'ESSENTIALS' or 'ADVANCED'."
  }
}

variable "cc_user_email" {
  description = "Confluent Cloud User's Email"
  type = string
}

variable "environment_display_name" {
  description = "Confluent Cloud Environment Display Name"
  type        = string
}

variable "cloud_provider" {
  description = "The selected cloud provider"
  type        = string
  default     = "AWS"

  validation {
    condition     = contains(["AWS"], var.cloud_provider)
    error_message = "The cloud_provider must be 'AWS' at this time."
  }
}

variable "cloud_region" {
  description = "The region in the selected cloud"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = contains(["us-east-1"], var.cloud_region)
    error_message = "The cloud_provider must be 'us-east-1' at this time."
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