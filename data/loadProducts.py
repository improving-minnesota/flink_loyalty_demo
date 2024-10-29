import json
import os
from kafka import KafkaProducer

# ########################################
# Configure Kafka producer
# Run - `terraform output resource-ids` in terraform/demo-infrastructure to expose these values.
# 
# Then:
# export DEMO_CLUSTER_BOOTSTRAP=<your boostrap url>
# export PRODUCT_API_KEY_ID=<your api key id>
# export PRODUCT_API_KEY_SECRET=<your api key secret>
#
# Then:
# python loadProducts.py
#
# ########################################

producer = KafkaProducer(
    bootstrap_servers= os.environ.get("DEMO_CLUSTER_BOOTSTRAP", "Set The Environment Var"),  # Environment Var For kafka bootstrap url (terraform output resource-ids)
    security_protocol='SASL_SSL',
    sasl_mechanism='PLAIN',

    sasl_plain_username= os.environ.get("PRODUCT_API_KEY_ID", "Set The Environment Var"),  # Environment Var For kafka API Key Id (terraform output resource-ids)
    sasl_plain_password= os.environ.get("PRODUCT_API_KEY_SECRET", "Set The Environment Var"),  # Environment Var For kafka API Key Secret (terraform output resource-ids)
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Read JSON array from file
with open('product-data.json', 'r') as file:
    data = json.load(file)

# Produce messages for each entry in the JSON array
for entry in data:
    producer.send('raw_products', value=entry)  # Replace 'your_topic' with your Kafka topic
    print(f"Produced: {entry}")

# Flush and close the producer
producer.flush()
producer.close()
