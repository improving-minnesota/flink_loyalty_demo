-------------
-- CREATE TABLE
-------------

-- Create a table for the enriched order data.

CREATE TABLE order_customer_product(
  order_id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  product_name STRING,
  sale_price INT,
  rating DOUBLE
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
--   product_name,
--   sale_price,
--   rating)
-- SELECT
--   o.order_id,
--   c.first_name,
--   c.last_name,
--   c.email,
--   p.name,
--   p.sale_price,
--   p.rating
-- FROM 
--   orders o
--   INNER JOIN customers c 
--     ON o.customer_id = c.id
--   INNER JOIN products p
--     ON o.product_id = p.id;