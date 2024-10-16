variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID) with OrganizationAdmin permissions"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
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
    #     {email = "flinkdemo2024+lce1@gmail.com", env_name="MotorCity"},
    #     {email = "flinkdemo2024+lce2@gmail.com", env_name="Woodward"},
    #     {email = "flinkdemo2024+lce3@gmail.com", env_name="Tigers"},
    #     {email = "flinkdemo2024+lce4@gmail.com", env_name="Lions"},
    #     {email = "flinkdemo2024+lce5@gmail.com", env_name="Pistons"},
    #     {email = "flinkdemo2024+lce6@gmail.com", env_name="RedWings"},
    #     {email = "flinkdemo2024+lce7@gmail.com", env_name="Corktown"},
    #     {email = "flinkdemo2024+lce8@gmail.com", env_name="EasternMarket"},
    #     {email = "flinkdemo2024+lce9@gmail.com", env_name="Riverfront"},
    #     {email = "flinkdemo2024+lce10@gmail.com", env_name="Fisher"},
    #     {email = "flinkdemo2024+lce11@gmail.com", env_name="FoxTheatre"},
    #     {email = "flinkdemo2024+lce12@gmail.com", env_name="Cobo"},
    #     {email = "flinkdemo2024+lce13@gmail.com", env_name="HartPlaza"},
    #     {email = "flinkdemo2024+lce14@gmail.com", env_name="BrushPark"},
    #     {email = "flinkdemo2024+lce15@gmail.com", env_name="Cadillac"},
    #     {email = "flinkdemo2024+lce16@gmail.com", env_name="Jefferson"},
    #     {email = "flinkdemo2024+lce17@gmail.com", env_name="Greektown"},
    #     {email = "flinkdemo2024+lce18@gmail.com", env_name="Lafayette"},
    #     {email = "flinkdemo2024+lce19@gmail.com", env_name="TechTown"},
    #     {email = "flinkdemo2024+lce20@gmail.com", env_name="NewCenter"}
    # ]
    
}