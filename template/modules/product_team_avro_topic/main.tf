terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.5.0"
    }
  }
}

resource "confluent_kafka_topic" "topic" {
  topic_name = var.topic_name
  config = var.topic_configs

  // cluster specific provider must be passed when using the module
}

resource "confluent_schema" "value_schema" {
  subject_name = "${var.topic_name}-value"
  format       = "AVRO"
  schema       = var.value_schema_file

  // cluster specific provider must be passed when using the module
}

// todo - required tags