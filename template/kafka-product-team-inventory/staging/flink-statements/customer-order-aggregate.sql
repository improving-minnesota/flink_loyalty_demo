INSERT INTO `shadowtraffic.customer.order-aggregate`
SELECT
  CAST(o.customerDetails.id AS BYTES) as key,
  CAST(o.customerDetails.id AS STRING) AS customerId,
  CAST(COUNT(o.orderDetails.id) AS BIGINT) AS totalOrders,
  CAST(SUM(o.orderDetails.quantity) AS BIGINT) AS totalItems,
  CAST(SUM(o.orderDetails.quantity * o.orderDetails.price) AS DOUBLE) AS totalSpent
FROM `shadowtraffic.order.full` AS o
GROUP BY o.customerDetails.id;