-------------
-- CREATE TABLE
-------------

-- Create a table for the enriched order data.

CREATE TABLE order_customer_product(
  order_id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  product_type STRING,
  product_name STRING,
  sale_price INT
)WITH (
    'changelog.mode' = 'retract'
);

-------------
-- INSERT DATA
-------------

-- Insert joined data from the 3 streams / tables.

-- INSERT INTO order_customer_product(
--   order_id,
--   first_name,
--   last_name,
--   email,
--   product_type,
--   product_name,
--   sale_price
--   )
-- SELECT
--   o.order_id,
--   c.first_name,
--   c.last_name,
--   c.email,
--   p.product_type,
--   p.product_name,
--   p.sale_price
-- FROM 
--   datagen_orders o
--   INNER JOIN datagen_customers c 
--     ON o.customer_id = c.id
--   INNER JOIN products p
--     ON o.product_id = p.id;