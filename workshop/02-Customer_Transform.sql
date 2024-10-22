INSERT INTO `customers`
SELECT 
  CAST(JSON_VALUE(customer_json, '$.id.S') as BYTES) as key,
  JSON_VALUE(customer_json, '$.id.S') as id,
  JSON_VALUE(customer_json, '$.first_name.S') as first_name,
  JSON_VALUE(customer_json, '$.last_name.S') as last_name,
  JSON_VALUE(customer_json, '$.email.S') as email,
  JSON_VALUE(customer_json, '$.phone.S') as phone,
  JSON_VALUE(customer_json, '$.street_address.S') as address,
  JSON_VALUE(customer_json, '$.state.S') as state,
  JSON_VALUE(customer_json, '$.zip_code.S') as zip_code,
  JSON_VALUE(customer_json, '$.country.S') as country,
  JSON_VALUE(customer_json, '$.country_code.S') as country_code
FROM 
  (  
     SELECT 
         JSON_VALUE(JSON_STRING(after), '$.document') as customer_json 
     FROM `lce_raw_customers`
  );