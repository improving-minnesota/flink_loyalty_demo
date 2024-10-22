-------------
-- PROMO 2 - BUNDLE UP -- Extramostbestest Pepperoni Puff Bundle
-------------


INSERT INTO promotions
SELECT
     email,
     'PROMO-BUNDLE-1' AS promotion_name
  FROM order_customer_product
  WHERE product_name IN ('Pepperoni Crazy Puffs', 'Extramostbestest Pepperoni')
  GROUP BY email
  HAVING COUNT(DISTINCT product_name) = 2 AND COUNT(product_name) > 10;
