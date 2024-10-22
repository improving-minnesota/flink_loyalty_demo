variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID) with OrganizationAdmin permissions"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "aws_api_key" {
  description = "AWS API Key for DynamoDB Access"
  type        = string
}

variable "aws_api_secret" {
  description = "AWS API Secret"
  type        = string
  sensitive   = true
}

variable "stream_governance_package" {
  description = "The selected stream governance package - more details can be found at https://docs.confluent.io/cloud/current/stream-governance/packages.html#governance-package-types"
  type        = string
  default     = "ESSENTIALS"

  validation {
    condition     = contains(["ESSENTIALS", "ADVANCED"], var.stream_governance_package)
    error_message = "The stream_governance_package must be either 'ESSENTIALS' or 'ADVANCED'."
  }
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

variable "environment_mappings" {
    type        = list
    description = "List of Email / Environment Mappings"

    default = [
        {email = "flinkdemo2024+nick1@gmail.com", env_name = "nick-env-1"}
    ]

    # default = [
    #     {email = "flinkdemo2024+lce001@gmail.com", env_name="workshop-001"},
    #     {email = "flinkdemo2024+lce002@gmail.com", env_name="workshop-002"},
    #     {email = "flinkdemo2024+lce003@gmail.com", env_name="workshop-003"},
    #     {email = "flinkdemo2024+lce004@gmail.com", env_name="workshop-004"},
    #     {email = "flinkdemo2024+lce005@gmail.com", env_name="workshop-005"},
    #     {email = "flinkdemo2024+lce006@gmail.com", env_name="workshop-006"},
    #     {email = "flinkdemo2024+lce007@gmail.com", env_name="workshop-007"},
    #     {email = "flinkdemo2024+lce008@gmail.com", env_name="workshop-008"},
    #     {email = "flinkdemo2024+lce009@gmail.com", env_name="workshop-009"},
    #     {email = "flinkdemo2024+lce010@gmail.com", env_name="workshop-010"},
    #     {email = "flinkdemo2024+lce011@gmail.com", env_name="workshop-011"},
    #     {email = "flinkdemo2024+lce012@gmail.com", env_name="workshop-012"},
    #     {email = "flinkdemo2024+lce013@gmail.com", env_name="workshop-013"},
    #     {email = "flinkdemo2024+lce014@gmail.com", env_name="workshop-014"},
    #     {email = "flinkdemo2024+lce015@gmail.com", env_name="workshop-015"},
    #     {email = "flinkdemo2024+lce016@gmail.com", env_name="workshop-016"},
    #     {email = "flinkdemo2024+lce017@gmail.com", env_name="workshop-017"},
    #     {email = "flinkdemo2024+lce018@gmail.com", env_name="workshop-018"},
    #     {email = "flinkdemo2024+lce019@gmail.com", env_name="workshop-019"},
    #     {email = "flinkdemo2024+lce020@gmail.com", env_name="workshop-020"}
    # ]
    
}