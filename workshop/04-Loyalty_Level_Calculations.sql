-------------
-- CREATE TABLE
-------------

-- Create a table for these loyalty levels.

CREATE TABLE loyalty_levels(
  email STRING,
  total BIGINT,
  loyalty_level STRING,
  PRIMARY KEY (email) NOT ENFORCED
);


-------------
-- INSERT DATA
-------------

-- Use the values determined from above to put the loyalty levels

-- INSERT INTO loyalty_levels
-- SELECT
--   email,
--   SUM(sale_price) AS total,
--   CASE
--     WHEN SUM(sale_price) > 20000 THEN 'GOLD'
--     WHEN SUM(sale_price) > 7500 THEN 'SILVER'
--     WHEN SUM(sale_price) > 1000 THEN 'BRONZE'
--     ELSE 'CLIMBING'
--   END AS loyalty_level
-- FROM order_customer_product
-- GROUP BY email;