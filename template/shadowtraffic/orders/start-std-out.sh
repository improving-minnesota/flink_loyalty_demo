docker run \
  --pull=always \
  --env-file ../license.env \
  -v $(pwd)/config:/config \
  -v $(pwd)/../../kafka-product-team-inventory/staging/schemas:/schemas \
  shadowtraffic/shadowtraffic:latest \
  --config /config/config-avro.json \
  --watch --sample 50 --stdout