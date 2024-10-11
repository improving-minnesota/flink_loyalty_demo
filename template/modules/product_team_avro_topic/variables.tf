variable "topic_name" {
  description = "The Kafka topic name"
  type        = string
}

variable "topic_configs" {
  description = "Map of Kafka Topic configurations"
  type        = map
  default = {}
}

variable "value_schema_file" {
  description = "The Avro schema file"
  type        = string
}

