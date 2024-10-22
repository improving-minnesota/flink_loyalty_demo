-------------
-- PROMO 1 - BUY 10, GET 1 FREE - Detroit-Style Deep Dish Ultimate Supreme Deal
-------------

INSERT INTO promotions
SELECT
   email,
   'PROMO-BSGO-1' AS promotion_name
FROM order_customer_product
WHERE product_name = 'Detroit-Style Deep Dish Ultimate Supreme'
GROUP BY email
HAVING COUNT(*) % 10 = 0;
