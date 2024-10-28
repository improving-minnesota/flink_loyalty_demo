resource "confluent_connector" "customer_source" {
  environment {
    id = confluent_environment.this.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }

  status = "PAUSED"

  // Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_sensitive = {
    "kafka.api.secret"         = confluent_api_key.cluster-admin-api-key.secret
  }

  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "customers-source"
    "kafka.api.key"            = confluent_api_key.cluster-admin-api-key.id
    "kafka.topic"              = confluent_kafka_topic.customers.topic_name
    "output.data.format"       = "AVRO"
    "quickstart"               = "SHOE_CUSTOMERS"
    "tasks.max"                = "1"
  }

  depends_on = [
    confluent_api_key.cluster-admin-api-key
  ]
}

resource "confluent_connector" "order_source" {
  environment {
    id = confluent_environment.this.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }

  status = "PAUSED"

  // Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_sensitive = {
    "kafka.api.secret"         = confluent_api_key.cluster-admin-api-key.secret
  }

  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "orders-source"
    "kafka.api.key"            = confluent_api_key.cluster-admin-api-key.id
    "kafka.topic"              = confluent_kafka_topic.orders.topic_name
    "output.data.format"       = "AVRO"
    "quickstart"               = "SHOE_ORDERS"
    "tasks.max"                = "1"
  }

  depends_on = [
    confluent_api_key.cluster-admin-api-key
  ]
}