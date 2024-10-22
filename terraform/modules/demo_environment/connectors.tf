resource "confluent_connector" "dynamodb_source" {
  environment {
    id = confluent_environment.this.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }

  // Block for custom *sensitive* configuration properties that are labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-amazon-dynamo-db-sink.html#configuration-properties
  config_sensitive = {}

// Block for custom *nonsensitive* configuration properties that are *not* labelled with "Type: password" under "Configuration Properties" section in the docs:
  // https://docs.confluent.io/cloud/current/connectors/cc-amazon-dynamo-db-sink.html#configuration-properties
  config_nonsensitive = {
    "connector.class"                   = "DynamoDbCdcSource"
    "name"                              = "dynamodb_source"
    "aws.access.key.id"                 = var.aws_api_key
    "aws.secret.access.key" = var.aws_api_secret  
    "dynamodb.service.endpoint"         = "https://dynamodb.us-east-1.amazonaws.com"
    "dynamodb.table.includelist"        = "customers, products"
    "kafka.api.key"                     = confluent_api_key.user-api-key.id 
    "kafka.api.secret"      = confluent_api_key.user-api-key.secret         
    "transforms"                        = "AddPrefix",
    "transforms.AddPrefix.type"         = "io.confluent.connect.cloud.transforms.TopicRegexRouter",
    "transforms.AddPrefix.regex"        = ".*",
    "transforms.AddPrefix.replacement"  = "lce_raw_$0"
    "tasks.max"                         = "1"
  }


  depends_on = []
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
    "kafka.api.secret"         = confluent_api_key.user-api-key.secret
  }

  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "order_source"
    "kafka.api.key"            = confluent_api_key.user-api-key.id    
    "kafka.topic"              = confluent_kafka_topic.orders.topic_name
    "output.data.format"       = "AVRO"
    "schema.string"            = file("./schemas/connectors/orders.avsc")
    "schema.keyfield"          = "order_id"
    "tasks.max"                = "1"
  }

  depends_on = [
    confluent_api_key.user-api-key
  ]
}