CREATE TABLE promotions(
  email STRING,
  promotion_name STRING,
  PRIMARY KEY (email) NOT ENFORCED
);

INSERT INTO promotions
SELECT
     email,
     COLLECT(name) AS products,
     'Extramostbestest Pepperony Puff Bundle' AS promotion_name
  FROM order_customer_product
  WHERE name IN ('Pepperoni Crazy Puffs', 'Extramostbestest Pepperoni')
  GROUP BY email
  HAVING COUNT(DISTINCT name) = 2 AND COUNT(name) > 2;


INSERT INTO promotions
SELECT
   email,
   'Buy 2 Get Next Free Extramostbestest Cheese' AS promotion_name
FROM order_customer_product
WHERE name = 'Extramostbestest Cheese'
GROUP BY email
HAVING COUNT(*) % 2 = 0;