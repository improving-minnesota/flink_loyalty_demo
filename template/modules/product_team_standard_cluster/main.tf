terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.5.0"
    }
  }
}

data "confluent_organization" "this" {}

data "confluent_environment" "this" {
  id = var.environment_id
}

data "confluent_schema_registry_cluster" "this" {
  environment {
    id = data.confluent_environment.this.id
  }

  depends_on = [ confluent_kafka_cluster.this ] 
}

// https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_kafka_cluster
resource "confluent_kafka_cluster" "this" {
  display_name = var.cluster_display_name

  cloud        = var.cloud_provider
  region       = var.cloud_region
  availability = var.cloud_availability

  standard {}
  environment {
    id = var.environment_id
  }
}

//
// CloudClusterAdmin API Key - https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#cloudclusteradmin
//

resource "confluent_service_account" "cluster-admin" {
  display_name = "${var.cluster_display_name}-cluster-admin"
  description  = "Service Account to manage the '${var.cluster_display_name}' Kafka cluster"
}

# Scope: Cluster
resource "confluent_role_binding" "cluster-admin-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.cluster-admin.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.this.rbac_crn
}

resource "confluent_api_key" "cluster-admin-kafka-api-key" {
  display_name = "${var.cluster_display_name}-cluster-admin-api-key"
  description  = "Kafka API Key that is owned by the '${confluent_service_account.cluster-admin.display_name}' service account"
  owner {
    id          = confluent_service_account.cluster-admin.id
    api_version = confluent_service_account.cluster-admin.api_version
    kind        = confluent_service_account.cluster-admin.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.this.id
    api_version = confluent_kafka_cluster.this.api_version
    kind        = confluent_kafka_cluster.this.kind

    environment {
      id = var.environment_id
    }
  }

  depends_on = [
    confluent_role_binding.cluster-admin-kafka-cluster-admin
  ]
}

//
// DataSteward API Key - https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#datasteward
//

// pull in the env admin service account (created in confluent_cloud_environment module)
data "confluent_service_account" "env-admin" {
  display_name = "env-admin-${data.confluent_environment.this.display_name}"
}

resource "confluent_api_key" "env-admin-data-steward-api-key" {
  display_name = "${var.cluster_display_name}-data-steward-api-key"
  description  = "Schema Registry API Key that is owned by the '${data.confluent_service_account.env-admin.display_name}' service account"
  owner {
    id          = data.confluent_service_account.env-admin.id
    api_version = data.confluent_service_account.env-admin.api_version
    kind        = data.confluent_service_account.env-admin.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.this.id
    api_version = data.confluent_schema_registry_cluster.this.api_version
    kind        = data.confluent_schema_registry_cluster.this.kind

    environment {
      id = data.confluent_environment.this.id
    }
  }
}

//
// DeveloperWrite - https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#developerwrite
//

resource "confluent_service_account" "cluster-developer-write" {
  display_name = "${var.cluster_display_name}-cluster-developer-write"
  description  = "Default DeveloperWrite Service Account for the '${var.cluster_display_name}' Kafka cluster"
}

# todo - temp fix to allow flink statements (shouldn't need full cloud cluster admin binding)
resource "confluent_role_binding" "cluster-developer-write-kafka-cluster-admin" {
  principal = "User:${confluent_service_account.cluster-developer-write.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.this.rbac_crn
}

# Scope: All Cluster Topics
resource "confluent_role_binding" "cluster-developer-topic-write-binding" {
  principal = "User:${confluent_service_account.cluster-developer-write.id}"
  # https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#developerwrite
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.this.rbac_crn}/kafka=${confluent_kafka_cluster.this.id}/topic=*"
}

resource "confluent_role_binding" "cluster-developer-data-discovery-binding" {
  principal = "User:${confluent_service_account.cluster-developer-write.id}"
  role_name   = "DataDiscovery"
  crn_pattern = data.confluent_environment.this.resource_name
}

# Scope: All Cluster Groups
resource "confluent_role_binding" "cluster-developer-group-write-binding" {
  principal = "User:${confluent_service_account.cluster-developer-write.id}"
  # https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#developerwrite
  role_name   = "DeveloperRead" # DeveloperWrite isn't a thing on groups
  crn_pattern = "${confluent_kafka_cluster.this.rbac_crn}/kafka=${confluent_kafka_cluster.this.id}/group=*"
}

# Scope: All Cluster Transactional IDs
resource "confluent_role_binding" "cluster-developer-transactional-id-resource-owner-binding" {
  principal = "User:${confluent_service_account.cluster-developer-write.id}"
  # https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#resourceowner
  role_name   = "ResourceOwner" # ResourceOwner
  crn_pattern = "${confluent_kafka_cluster.this.rbac_crn}/kafka=${confluent_kafka_cluster.this.id}/transactional-id=*"
}

resource "confluent_api_key" "cluster-developer-write-kafka-api-key" {
  display_name = "${var.cluster_display_name}-cluster-developer-write-api-key"
  description  = "Kafka API Key that is owned by the '${confluent_service_account.cluster-admin.display_name}' service account"
  owner {
    id          = confluent_service_account.cluster-developer-write.id
    api_version = confluent_service_account.cluster-developer-write.api_version
    kind        = confluent_service_account.cluster-developer-write.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.this.id
    api_version = confluent_kafka_cluster.this.api_version
    kind        = confluent_kafka_cluster.this.kind

    environment {
      id = var.environment_id
    }
  }

  depends_on = [
    confluent_role_binding.cluster-developer-topic-write-binding,
    confluent_role_binding.cluster-developer-group-write-binding
  ]
}

//
// DeveloperRead - https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#developerread
//

resource "confluent_service_account" "cluster-developer-read" {
  display_name = "${var.cluster_display_name}-cluster-developer-read"
  description  = "Default DeveloperRead Service Account for the '${var.cluster_display_name}' Kafka cluster"
}

# Scope: All Cluster Topics
resource "confluent_role_binding" "cluster-developer-topic-read-binding" {
  principal = "User:${confluent_service_account.cluster-developer-read.id}"
  # https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#developerread
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.this.rbac_crn}/kafka=${confluent_kafka_cluster.this.id}/topic=*"
}

# Scope: All Cluster Groups
resource "confluent_role_binding" "cluster-developer-group-read-binding" {
  principal = "User:${confluent_service_account.cluster-developer-read.id}"
  # https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#developerread
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.this.rbac_crn}/kafka=${confluent_kafka_cluster.this.id}/group=*"
}

resource "confluent_api_key" "cluster-developer-read-kafka-api-key" {
  display_name = "${var.cluster_display_name}-cluster-developer-read-api-key"
  description  = "Kafka API Key that is owned by the '${confluent_service_account.cluster-admin.display_name}' service account"
  owner {
    id          = confluent_service_account.cluster-developer-read.id
    api_version = confluent_service_account.cluster-developer-read.api_version
    kind        = confluent_service_account.cluster-developer-read.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.this.id
    api_version = confluent_kafka_cluster.this.api_version
    kind        = confluent_kafka_cluster.this.kind

    environment {
      id = var.environment_id
    }
  }

  depends_on = [
    confluent_role_binding.cluster-developer-topic-read-binding,
    confluent_role_binding.cluster-developer-group-read-binding
  ]
}

