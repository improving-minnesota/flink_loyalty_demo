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

resource "confluent_service_account" "env-admin" {
  display_name = "env-admin-${var.environment_display_name}"
  description  = "Service account to manage resources under '${var.environment_display_name}' environment"
}

// Scope: Environment
resource "confluent_role_binding" "env-admin-env-admin" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.this.resource_name
}

// https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#accountadmin
resource "confluent_role_binding" "env-admin-account-admin" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "AccountAdmin"
  crn_pattern = data.confluent_organization.this.resource_name
}

# Scope: Stream Governance (Schema Registry)
resource "confluent_role_binding" "env-admin-data-steward" {
  principal   = "User:${confluent_service_account.env-admin.id}"
  role_name   = "DataSteward"
  crn_pattern = confluent_environment.this.resource_name
}

resource "confluent_api_key" "env-admin-cloud-api-key" {
  display_name = "env-admin-${var.environment_display_name}-api-key"
  description  = "Cloud API Key to be shared with Product teams managing resources within the '${var.environment_display_name}' environment"
  owner {
    id          = confluent_service_account.env-admin.id
    api_version = confluent_service_account.env-admin.api_version
    kind        = confluent_service_account.env-admin.kind
  }

  depends_on = [
    confluent_role_binding.env-admin-env-admin,
    confluent_role_binding.env-admin-account-admin,
  ]
}

## ENV SCOPED METRICS VIEWER API TOKEN

resource "confluent_service_account" "env_metrics_viewer" {
  display_name = "${var.environment_display_name}-env-metrics-viewer"
  description  = "Service account to import Confluent Cloud Metrics into 3rd party solutions (ex. Grafana Cloud)"
}

# https://docs.confluent.io/cloud/current/access-management/access-control/rbac/predefined-rbac-roles.html#metricsviewer
resource "confluent_role_binding" "env_metrics_viewer_role_binding" {
  principal   = "User:${confluent_service_account.env_metrics_viewer.id}"
  role_name   = "MetricsViewer"
  crn_pattern = confluent_environment.this.resource_name
}

resource "confluent_api_key" "env_metrics_viewer_api_key" {
  display_name = "env_metrics_viewer_api_key"
  description  = "Cloud API Key to be used in 3rd party tools connecting to the Confluent Cloud Metrics API."
  owner {
    id          = confluent_service_account.env_metrics_viewer.id
    api_version = confluent_service_account.env_metrics_viewer.api_version
    kind        = confluent_service_account.env_metrics_viewer.kind
  }

  depends_on = [
    confluent_role_binding.env_metrics_viewer_role_binding
  ]
}