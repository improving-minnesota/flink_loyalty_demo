INSERT INTO `products`
SELECT 
  CAST(JSON_VALUE(product_json, '$.id') as BYTES) as key,
  JSON_VALUE(product_json, '$.id') as id,
  JSON_VALUE(product_json, '$.name') as product_name,
  JSON_VALUE(product_json, '$.product_type') as product_type,
  CAST(JSON_VALUE(product_json, '$.sale_price') as INT) as sale_price
FROM 
  (  
    SELECT 
      CAST(rp.val as STRING) as product_json
    FROM `raw_products` rp
  );