output "topic" {
  description = "The Kafka Topic that was provisioned in the provided cluster"
  value       = confluent_kafka_topic.topic
}

output "topic_value_schema" {
  description = "The Kafka Topic that was provisioned in the provided cluster"
  value       = confluent_schema.value_schema
}