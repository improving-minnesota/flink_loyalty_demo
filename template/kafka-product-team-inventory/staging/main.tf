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

// import a reference to the target environment
data "confluent_environment" "this" {
  display_name = "staging"
}

data "confluent_schema_registry_cluster" "this" {
  environment {
    id = data.confluent_environment.this.id
  }
  depends_on = [ module.inventory_cluster ] 
}

// confluent_kafka_cluster
module "inventory_cluster" {
  source = "../../modules/product_team_standard_cluster"

  cluster_display_name   = "inventory"
  environment_id         = data.confluent_environment.this.id
  enable_flink_workspace = true

  providers = {
    confluent = confluent
  }
}

/*********************
*  CLUSTER PROVIDER  *
**********************/

// setup provider linked to the 'inventory' cluster to simplify resource creation within cluster
//provider "confluent" {
//  alias = "inventory_cluster"
//
//  organization_id       = data.confluent_organization.this.id
//  environment_id        = data.confluent_environment.this.id
//
//  kafka_id            = module.inventory_cluster.confluent_kafka_cluster.id
//  kafka_rest_endpoint = module.inventory_cluster.confluent_kafka_cluster.rest_endpoint
//  kafka_api_key       = module.inventory_cluster.cluster_admin_api_key.id
//  kafka_api_secret    = module.inventory_cluster.cluster_admin_api_key.secret
//
//  schema_registry_id            = data.confluent_schema_registry_cluster.this.id
//  schema_registry_rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint
//  schema_registry_api_key       = module.inventory_cluster.data_steward_api_key.id
//  schema_registry_api_secret    = module.inventory_cluster.data_steward_api_key.secret
//
//  flink_compute_pool_id = module.inventory_cluster.flink_compute_pool_id
//  flink_rest_endpoint   = module.inventory_cluster.flink_rest_endpoint
//  # statements managed with the 'flink admin' service account
//  flink_api_key         = module.inventory_cluster.flink_admin_api_key.id
//  flink_api_secret      = module.inventory_cluster.flink_admin_api_key.secret
//  # statements run with the cluster level 'developer write' service account
//  flink_principal_id    = module.inventory_cluster.developer_write_service_account.id
//}

/********************
* CLUSTER RESOURCES *
*********************/

//module "customers_topic" {
//  source = "../../modules/product_team_avro_topic"
//
//  topic_name        = "shadowtraffic.customer.profile"
//  value_schema_file = file("./schemas/avro/customer.avsc")
//
//  providers = {
//    confluent = confluent.inventory_cluster
//  }
//}
//
//module "items_topic" {
//  source = "../../modules/product_team_avro_topic"
//
//  topic_name        = "shadowtraffic.item.profile"
//  value_schema_file = file("./schemas/avro/item.avsc")
//
//  providers = {
//    confluent = confluent.inventory_cluster
//  }
//}
//
//module "orders_topic" {
//  source = "../../modules/product_team_avro_topic"
//
//  topic_name        = "shadowtraffic.order.created"
//  value_schema_file = file("./schemas/avro/order.avsc")
//
//  providers = {
//    confluent = confluent.inventory_cluster
//  }
//}
//
//// sink for FlinkSQL Join of Orders, Customers, and Items
//module "full_orders_topic" {
//  source = "../../modules/product_team_avro_topic"
//
//  topic_name        = "shadowtraffic.order.full"
//  value_schema_file = file("./schemas/avro/full-order.avsc")
//
//  providers = {
//    confluent = confluent.inventory_cluster
//  }
//}
//
//resource "confluent_flink_statement" "customer_order_join" {
//  statement  = file("./flink-statements/order-item-customer-join.sql")
//
//  statement_name = "inventory-order-item-customer-join"
//
//  properties = local.flink_default_properties
//
//  depends_on = [
//    # source
//    module.customers_topic,
//    module.orders_topic,
//    module.items_topic,
//
//    # sink
//    module.full_orders_topic
//  ]
//
//  provider = confluent.inventory_cluster
//}
//
//// sink for FlinkSQL Join of Orders, Customers, and Items
//module "customer_orders_aggregate_topic" {
//  source = "../../modules/product_team_avro_topic"
//
//  topic_name        = "shadowtraffic.customer.order-aggregate"
//  topic_configs = {
//    "cleanup.policy"                      = "compact"
//  }
//  value_schema_file = file("./schemas/avro/customer-order-aggregate.avsc")
//
//  providers = {
//    confluent = confluent.inventory_cluster
//  }
//}
//
//resource "confluent_flink_statement" "customer_order_aggregate" {
//  statement  = file("./flink-statements/customer-order-aggregate.sql")
//
//  statement_name = "inventory-customer-order-aggregate"
//
//  properties = local.flink_default_properties
//
//  depends_on = [
//    # source
//    module.full_orders_topic,
//
//    # sink
//    module.customer_orders_aggregate_topic
//  ]
//
//  provider = confluent.inventory_cluster
//}