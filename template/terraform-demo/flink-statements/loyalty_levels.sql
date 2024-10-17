CREATE TABLE loyalty_levels(
  email STRING,
  total BIGINT,
  rewards_level STRING,
  PRIMARY KEY (email) NOT ENFORCED
);

INSERT INTO loyalty_levels
SELECT
  email,
  SUM(sale_price) AS total,
  CASE
    WHEN SUM(sale_price) > 20000 THEN 'GOLD'
    WHEN SUM(sale_price) > 7500 THEN 'SILVER'
    WHEN SUM(sale_price) > 1000 THEN 'BRONZE'
    ELSE 'CLIMBING'
  END AS rewards_level
FROM order_customer_product
GROUP BY email;