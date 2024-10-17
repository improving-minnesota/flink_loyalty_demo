terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.5.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

data "confluent_organization" "this" {}

// the pre-provisioned environment (we won't use this)
data "confluent_environment" "default" {
  display_name = "default"
}

module "demo_environment" {
  for_each = {for i, v in var.environment_mappings:  i => v}
  source = "../modules/confluent_cloud_environment"

  environment_display_name  = "demo-${each.value.env_name}"
  cc_user_email = each.value.email
  stream_governance_package = "ESSENTIALS"

  aws_api_key = var.aws_api_key
  aws_api_secret = var.aws_api_secret

  providers = {
    confluent = confluent
  }
}

