# ShadowTraffic

[https://shadowtraffic.io](https://docs.shadowtraffic.io/overview/) enables rapid simulation of data into various data technologies. In our case, we're going to be using it to produce data into our Confluent Cloud topics.

## Prerequisites

1. Inside the `/shadowtraffic` folder, create a copy of `template_license.env` and rename it to `license.env`
   - NOTE: `.gitignore` will keep the `license.env` file out of your commit history.
2. Fill in the license details ([Sign Up for Free Trial Here](https://shadowtraffic.io/pricing.html))
3. `cd shadowtraffic/orders`
4. Test that things are working by running 👉 `./start-std-out.sh`
   - This will pull the latest shadowtraffic docker image (`--pull=always`) and dump a few samples into your terminal's std out (**these records do not get produced to Kafka**)

## ShadowTraffic Directory Guide

Below is a guide to the `/shadowtraffic` directory and the various files/folders that you'll find.
   
```txt
./shadowtraffic
├── orders
│   ├── config
│   │   ├── connections
│   │   │   ├── template_staging-kafka.json  # Template Connection File: Copy + Paste + Rename to "staging-kafka.json" 
│   │   │   ├── staging-kafka.json           # JSON connection block for the staging cluster (`terraform output shadowtraffic-config`) 
│   │   │   └── ... other connection files
│   │   ├── generators
│   │   │   ├── customer-profile.json        # Generator that produces Customer Profiles
│   │   │   ├── item-profile.json            # Generator that produces Item Profiles (Products)
│   │   │   ├── order.json                   # Generator that produces Orders (Customer buying Item(s))
│   │   │   └── ... other generator files
│   │   ├── stages
│   │   │   ├── seed.json                    # Configuration for the "seed" stage (initial quantities of each entity)
│   │   │   ├── live.json                    # Configuration for the "live" stage (long running phase)
│   │   │   └── ... other seed files
│   │   └── config-avro.json                 # Root configuration that glues together generators, stages, and connections
│   ├── start-kafka.sh                       # Runs ShadowTraffic, pointed at staging-kafka connection (Confluent Cloud)
│   └── start-std-out.sh                     # Runs ShadowTraffic, pointed at std-out (local) -- useful for testing
├── license.env                              # ShadowTraffic License File -> https://shadowtraffic.io/pricing.html
└── template_license.env                     # Template License File: Copy + Paste + Rename to create your own
```

## Producing to Confluent Cloud

> ⚠️ You must have your Confluent Cloud environment, cluster, topics, etc. provisioned before continuing. Additional details can be found in this repo's [root readme](../../README.md).

In the ShadowTraffic `/config/connections` folder, there is a `template_staging-kafka.json` JSON file. 

1. Copy + Paste this file, renaming it to `staging-kafka.json`. This will hold your actual connection details and because of this, it's ignored by Git (hence the template vs real file setup).
2. Now, in the "real" `staging-kafka.json` file we need to replace the contents with our own Confluent Cloud's connection details.
3. From your `kafka-product-team-*/{env}` folder, run `terraform output shadowtraffic-config` to gather the JSON connection configuration block.
   - ex. `/kafka-product-team-inventory/staging > terraform output shadowtraffic-config`

   ```json
   /kafka-product-team-inventory/staging > terraform output shadowtraffic-config
   
   # Replace the value in `/shadowtraffic/orders/config/connections/staging-kafka.json` with the value below
   
   {
      "bootstrap.servers": "SASL_SSL://pkc-12345.us-east1.gcp.confluent.cloud:9092",
      "sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username='xxx' password='xxxxxx';",
      "schema.registry.url": "https://psrc-12345.us-east1.gcp.confluent.cloud",
      "basic.auth.user.info": "xxxx:xxxxxxx",
      
      "key.serializer": "org.apache.kafka.common.serialization.StringSerializer",
      "value.serializer": "io.confluent.kafka.serializers.KafkaAvroSerializer",
      "basic.auth.credentials.source": "USER_INFO",
      "sasl.mechanism": "PLAIN",
      "security.protocol": "SASL_SSL",
      "client.dns.lookup": "use_all_dns_ips"
   }
   ```

## Produce to Kafka

Once the `staging-kafka.json` is filled with your connection block, run `./start-kafka.sh` to start producing data to Confluent Cloud.

## ShadowTraffic Examples

For more details on ShadowTraffic, visit the [docs](https://docs.shadowtraffic.io/) and [additional examples](https://github.com/shadowtraffic/shadowtraffic-examples).