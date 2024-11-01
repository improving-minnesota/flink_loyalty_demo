terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.5.0"
    }
  }
}

data "confluent_organization" "this" {}

resource "confluent_environment" "this" {
  display_name = var.environment_display_name

  stream_governance {
    package = var.stream_governance_package
  }
}

data "confluent_schema_registry_cluster" "this" {
  environment {
    id = confluent_environment.this.id
  }

  depends_on = [ confluent_kafka_cluster.this ] 
}

data "confluent_flink_region" "this" {
  cloud  = var.cloud_provider
  region = var.cloud_region
}

resource "confluent_service_account" "env-admin" {
  display_name = "env-admin-${var.environment_display_name}"
  description  = "Service account to manage resources under '${var.environment_display_name}' environment"
}

resource "confluent_api_key" "cluster-admin-api-key" {
  display_name = "Cluster Admin API Key"
  owner {
    id          = confluent_service_account.env-admin.id
    api_version = confluent_service_account.env-admin.api_version
    kind        = confluent_service_account.env-admin.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.this.id
    api_version = confluent_kafka_cluster.this.api_version
    kind        = confluent_kafka_cluster.this.kind

    environment {
      id = confluent_environment.this.id
    }
  }


  depends_on = [ confluent_role_binding.sa-env-admin ]

}

resource "confluent_api_key" "data-steward-api-key" {
  display_name = "User Data Steward API Key"
  
  owner {
    id          = confluent_service_account.env-admin.id
    api_version = confluent_service_account.env-admin.api_version
    kind        = confluent_service_account.env-admin.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.this.id
    api_version = data.confluent_schema_registry_cluster.this.api_version
    kind        = data.confluent_schema_registry_cluster.this.kind

    environment {
      id = confluent_environment.this.id
    }
  }
}

resource "confluent_api_key" "flink-admin-api-key" {
  display_name = "Flink Admin API Key"

  owner {
    id          = confluent_service_account.env-admin.id
    api_version = confluent_service_account.env-admin.api_version
    kind        = confluent_service_account.env-admin.kind
  }
  managed_resource {
    id          = data.confluent_flink_region.this.id
    api_version = data.confluent_flink_region.this.api_version
    kind        = data.confluent_flink_region.this.kind
    environment {
      id = confluent_environment.this.id
    }
  }
}

/*************
  CLUSTER
*************/

// https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster
resource "confluent_kafka_cluster" "this" {
  display_name = "demo-cluster"

  cloud        = var.cloud_provider
  region       = var.cloud_region
  availability = var.cloud_availability

  standard {}
  environment {
    id = confluent_environment.this.id
  }
}

/*************
  FLINK
*************/

// https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_flink_compute_pool
resource "confluent_flink_compute_pool" "main" {

  display_name = "${confluent_kafka_cluster.this.display_name}-compute-pool"
  cloud        = var.cloud_provider
  region       = var.cloud_region
  // Maximum number of Confluent Flink Units (CFUs) that the Flink compute pool should auto-scale to. The accepted values are: 5, 10, 20, 30, 40 and 50.
  max_cfu = 10

  environment {
    id = confluent_environment.this.id
  }

  depends_on = [
    confluent_role_binding.cluster-flink-admin
  ]
}

/*************
  RBACs
*************/

// Scope: Environment
resource "confluent_role_binding" "sa-env-admin" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.this.resource_name
}

# Scope: Stream Governance (Schema Registry)
resource "confluent_role_binding" "env-admin-data-steward" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "DataSteward"
  crn_pattern = confluent_environment.this.resource_name
}

resource "confluent_role_binding" "env-admin-developer-write" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.this.rbac_crn}/kafka=${confluent_kafka_cluster.this.id}/topic=*"
}

resource "confluent_role_binding" "env-admin-developer-read" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.this.rbac_crn}/kafka=${confluent_kafka_cluster.this.id}/topic=*"
}

resource "confluent_role_binding" "cluster-flink-admin" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "FlinkAdmin"
  crn_pattern = confluent_environment.this.resource_name
}

resource "confluent_role_binding" "cluster-flink-admin-assignmer" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "Assigner"
  crn_pattern = "${data.confluent_organization.this.resource_name}/service-account=${confluent_service_account.env-admin.id}"
}
