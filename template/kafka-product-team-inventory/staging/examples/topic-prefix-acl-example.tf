//
//// EX - Service Account / API Key with access to topics based on prefix -
//
//resource "confluent_service_account" "shadow-consumer" {
//  display_name = "shadow-consumer"
//  description  = "Service account to consume from 'orders' topic of 'inventory' Kafka cluster"
//}
//
//resource "confluent_api_key" "shadow-consumer-kafka-api-key" {
//  display_name = "shadow-consumer-kafka-api-key"
//  description  = "Kafka API Key that is owned by 'shadow-consumer' service account"
//  owner {
//    id          = confluent_service_account.shadow-consumer.id
//    api_version = confluent_service_account.shadow-consumer.api_version
//    kind        = confluent_service_account.shadow-consumer.kind
//  }
//
//  managed_resource {
//    id          = module.inventory_cluster.id
//    api_version = module.inventory_cluster.confluent_kafka_cluster.api_version
//    kind        = module.inventory_cluster.confluent_kafka_cluster.kind
//
//    environment {
//      id = data.confluent_environment.this.id
//    }
//  }
//}
//
//resource "confluent_kafka_acl" "shadow-producer-write-on-topic" {
//  resource_type = "TOPIC"
//  resource_name = "shadowtraffic."
//  pattern_type  = "PREFIXED"
//  principal     = "User:${confluent_service_account.shadow-producer.id}"
//  host          = "*"
//  operation     = "WRITE"
//  permission    = "ALLOW"
//
//  provider = confluent.inventory_cluster
//}
//
//resource "confluent_service_account" "shadow-producer" {
//  display_name = "shadow-producer"
//  description  = "Service Account to produce to 'shadowtraffic.*' topics in the 'inventory' Kafka cluster"
//}
//
//resource "confluent_api_key" "shadow-producer-kafka-api-key" {
//  display_name = "shadow-producer-kafka-api-key"
//  description  = "Kafka API Key that is owned by 'shadow-producer' service account"
//  owner {
//    id          = confluent_service_account.shadow-producer.id
//    api_version = confluent_service_account.shadow-producer.api_version
//    kind        = confluent_service_account.shadow-producer.kind
//  }
//
//  managed_resource {
//    id          = module.inventory_cluster.id
//    api_version = module.inventory_cluster.confluent_kafka_cluster.api_version
//    kind        = module.inventory_cluster.confluent_kafka_cluster.kind
//
//    environment {
//      id = data.confluent_environment.this.id
//    }
//  }
//}
//
//// Note that in order to consume from a topic, the principal of the consumer ('shadow-consumer' service account)
//// needs to be authorized to perform 'READ' operation on both Topic and Group resources:
//// confluent_kafka_acl.shadow-consumer-read-on-topic, confluent_kafka_acl.shadow-consumer-read-on-group.
//// https://docs.confluent.io/platform/current/kafka/authorization.html#using-acls
//resource "confluent_kafka_acl" "shadow-consumer-read-on-topic" {
//  resource_type = "TOPIC"
//  resource_name = "shadowtraffic."
//  pattern_type  = "PREFIXED"
//  principal     = "User:${confluent_service_account.shadow-consumer.id}"
//  host          = "*"
//  operation     = "READ"
//  permission    = "ALLOW"
//
//  provider = confluent.inventory_cluster
//}
//
//resource "confluent_kafka_acl" "shadow-consumer-read-on-group" {
//  resource_type = "GROUP"
//  // service account read access to group metadata for group.ids starting with "shadow"
//  resource_name = "shadow"
//  pattern_type  = "PREFIXED"
//  principal     = "User:${confluent_service_account.shadow-consumer.id}"
//  host          = "*"
//  operation     = "READ"
//  permission    = "ALLOW"
//
//  provider = confluent.inventory_cluster
//}
