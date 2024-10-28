-------------
-- PROMO 1 - BUY 6, GET 1 FREE - Pizza,Pizza,Pizza,Pizza,Pizza,Pizza
-------------

INSERT INTO promotions
SELECT
   email,
   'PROMO-BSGO-1' AS promotion_name
FROM order_customer_product
WHERE product_type = 'Pizza'
GROUP BY email
HAVING COUNT(*) % 6 = 0;
