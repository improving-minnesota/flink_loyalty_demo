/*************
  TOPICS
*************/

resource "confluent_kafka_topic" "products" {

    topic_name         = "datagen-products"
    rest_endpoint      = confluent_kafka_cluster.this.rest_endpoint
    
    kafka_cluster {
        id = confluent_kafka_cluster.this.id
    }

    credentials {
        key = confluent_api_key.user-api-key.id
        secret = confluent_api_key.user-api-key.secret
    }
}

resource "confluent_kafka_topic" "customers" {
    kafka_cluster {
        id = confluent_kafka_cluster.this.id
    }

    topic_name         = "datagen-customers"
    rest_endpoint      = confluent_kafka_cluster.this.rest_endpoint

    credentials {
        key = confluent_api_key.user-api-key.id
        secret = confluent_api_key.user-api-key.secret
    }  
}

resource "confluent_kafka_topic" "orders" {
    kafka_cluster {
        id = confluent_kafka_cluster.this.id
    }

    topic_name         = "datagen-orders"
    rest_endpoint      = confluent_kafka_cluster.this.rest_endpoint

    credentials {
        key = confluent_api_key.user-api-key.id
        secret = confluent_api_key.user-api-key.secret
    }    
}
