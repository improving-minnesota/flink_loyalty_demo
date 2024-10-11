//
// Flink Compute Cluster
//

data "confluent_flink_region" "this" {
  // conditionally source the flink region
  count = var.enable_flink_workspace ? 1 : 0

  cloud  = var.cloud_provider
  region = var.cloud_region
}

// https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/confluent_flink_compute_pool
resource "confluent_flink_compute_pool" "main" {
  // conditionally create the compute pool
  count = var.enable_flink_workspace ? 1 : 0

  display_name = "${var.cluster_display_name}_compute_pool"
  cloud        = var.cloud_provider
  region       = var.cloud_region
  // Maximum number of Confluent Flink Units (CFUs) that the Flink compute pool should auto-scale to. The accepted values are: 5, 10, 20, 30, 40 and 50.
  max_cfu = 10

  environment {
    id = var.environment_id
  }

  depends_on = [
    confluent_role_binding.cluster-admin-kafka-cluster-admin,
    confluent_role_binding.cluster-flink-admin,
    confluent_api_key.cluster-flink-admin-api-key
  ]
}

//
// Flink API Key
//

// Service account to perform a task within Confluent Cloud, such as executing a Flink statement
resource "confluent_service_account" "cluster-flink-admin" {
  // conditionally create the service account
  count = var.enable_flink_workspace ? 1 : 0

  display_name = "${var.cluster_display_name}-flink-admin"
  description  = "Service Account for running Flink Statements within the '${var.cluster_display_name}' Kafka Cluster"
}

resource "confluent_role_binding" "cluster-flink-admin" {
  // conditionally create the role binding
  count = var.enable_flink_workspace ? 1 : 0

  principal = "User:${confluent_service_account.cluster-flink-admin[0].id}"
  // could be FlinkDeveloper?
  role_name   = "FlinkAdmin"
  crn_pattern = data.confluent_environment.this.resource_name
}

// https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#assigner
// https://docs.confluent.io/cloud/current/flink/operate-and-deploy/flink-rbac.html#submit-long-running-statements
resource "confluent_role_binding" "cluster-flink-admin-assignmer" {
  // conditionally create the role binding
  count = var.enable_flink_workspace ? 1 : 0

  principal = "User:${confluent_service_account.cluster-flink-admin[0].id}"
  role_name   = "Assigner"

  crn_pattern = "${data.confluent_organization.this.resource_name}/service-account=${confluent_service_account.cluster-developer-write.id}"
}

resource "confluent_api_key" "cluster-flink-admin-api-key" {
  // conditionally create the role binding
  count = var.enable_flink_workspace ? 1 : 0

  display_name = "${var.cluster_display_name}-flink-admin-api-key"
  description  = "Flink API Key that is owned by '${var.cluster_display_name}-flink-admin' service account"
  owner {
    id          = confluent_service_account.cluster-flink-admin[0].id
    api_version = confluent_service_account.cluster-flink-admin[0].api_version
    kind        = confluent_service_account.cluster-flink-admin[0].kind
  }
  managed_resource {
    id          = data.confluent_flink_region.this[0].id
    api_version = data.confluent_flink_region.this[0].api_version
    kind        = data.confluent_flink_region.this[0].kind
    environment {
      id = var.environment_id
    }
  }
}