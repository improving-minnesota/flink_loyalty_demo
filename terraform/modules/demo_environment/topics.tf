/*************
  TOPICS
*************/

resource "confluent_kafka_topic" "raw_products" {

    topic_name         = "lce_raw_products"
    rest_endpoint      = confluent_kafka_cluster.this.rest_endpoint

    kafka_cluster {
        id = confluent_kafka_cluster.this.id
    }

    credentials {
        key = confluent_api_key.user-api-key.id
        secret = confluent_api_key.user-api-key.secret
    }
}

resource "confluent_kafka_topic" "raw_customers" {
    kafka_cluster {
        id = confluent_kafka_cluster.this.id
    }

    topic_name         = "lce_raw_customers"
    rest_endpoint      = confluent_kafka_cluster.this.rest_endpoint

    credentials {
        key = confluent_api_key.user-api-key.id
        secret = confluent_api_key.user-api-key.secret
    }  
}


resource "confluent_kafka_topic" "products" {

    topic_name         = "products"
    rest_endpoint      = confluent_kafka_cluster.this.rest_endpoint

    config = {
        "cleanup.policy" = "compact"
    }
    
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

        config = {
        "cleanup.policy" = "compact"
    }

    topic_name         = "customers"
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

    topic_name         = "orders"
    rest_endpoint      = confluent_kafka_cluster.this.rest_endpoint

    credentials {
        key = confluent_api_key.user-api-key.id
        secret = confluent_api_key.user-api-key.secret
    }    
}

/*************
  SCHEMAS
*************/

resource "confluent_schema" "orders_schema" {
  subject_name = "orders-value"
  format       = "AVRO"
  schema       = file("./schemas/avro/orders.avsc")

  rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.this.id
  }

  credentials {
    key = confluent_api_key.data-steward-api-key.id
    secret = confluent_api_key.data-steward-api-key.secret
  }
}

resource "confluent_schema" "customers_schema" {
  subject_name = "customers-value"
  format       = "AVRO"
  schema       = file("./schemas/avro/customers.avsc")

  rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.this.id
  }

  credentials {
    key = confluent_api_key.data-steward-api-key.id
    secret = confluent_api_key.data-steward-api-key.secret
  }
}

resource "confluent_schema" "products_schema" {
  subject_name = "products-value"
  format       = "AVRO"
  schema       = file("./schemas/avro/products.avsc")

  rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.this.id
  }

  credentials {
    key = confluent_api_key.data-steward-api-key.id
    secret = confluent_api_key.data-steward-api-key.secret
  }
}

