-------------
-- PROMO 2 - BUNDLE UP
-------------

INSERT INTO promotions
SELECT
     email,
     'PROMO-BUNDLE-1' AS promotion_name
  FROM order_customer_product
  WHERE product_type IN ('Drinks', 'Detroit-Style Pizza')
  GROUP BY email
  HAVING COUNT(DISTINCT product_type) = 2;
