INSERT INTO `products`
SELECT 
  CAST(JSON_VALUE(product_json, '$.id.S') as BYTES) as key,
  JSON_VALUE(product_json, '$.id.S') as id,
  JSON_VALUE(product_json, '$.name.S') as `name`,
  CAST(JSON_VALUE(product_json, '$.sale_price.N') as INT) as sale_price,
  CAST(JSON_VALUE(product_json, '$.rating.N') as DOUBLE) as rating
FROM 
  (  
     SELECT 
         JSON_VALUE(JSON_STRING(after), '$.document') as product_json 
     FROM `lce_raw_products`
  );