resource "confluent_connector" "product_source" {
  environment {
    id = confluent_environment.this.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }

  // Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "product_source"
    "kafka.api.key"            = confluent_api_key.user-api-key.id
    "kafka.api.secret"         = confluent_api_key.user-api-key.secret
    "kafka.topic"              = confluent_kafka_topic.products.topic_name
    "output.data.format"       = "JSON"
    "schema.string"            = file("./schemas/avro/products.avsc")
    "tasks.max"                = "1"
  }
  config_sensitive = {}

  depends_on = [
    confluent_api_key.user-api-key
  ]
}

resource "confluent_connector" "customer_source" {
  environment {
    id = confluent_environment.this.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }

  // Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "customer_source"
    "kafka.api.key"            = confluent_api_key.user-api-key.id
    "kafka.api.secret"         = confluent_api_key.user-api-key.secret
    "kafka.topic"              = confluent_kafka_topic.customers.topic_name
    "output.data.format"       = "JSON"
    "schema.string"            = file("./schemas/avro/customers.avsc")
    "tasks.max"                = "1"
  }
  config_sensitive = {}

  depends_on = [     
    confluent_api_key.user-api-key 
  ]
}

resource "confluent_connector" "order_source" {
  environment {
    id = confluent_environment.this.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }

  // Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-datagen-source.html#configuration-properties
  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "order_source"
    "kafka.api.key"            = confluent_api_key.user-api-key.id
    "kafka.api.secret"         = confluent_api_key.user-api-key.secret
    "kafka.topic"              = confluent_kafka_topic.orders.topic_name
    "output.data.format"       = "JSON"
    "schema.string"            = file("./schemas/avro/orders.avsc")
    "tasks.max"                = "1"
  }
  config_sensitive = {}

  depends_on = [
    confluent_api_key.user-api-key
  ]
}