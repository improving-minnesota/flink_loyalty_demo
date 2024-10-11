INSERT INTO `shadowtraffic.order.full`
SELECT
  -- Map customerid to record key
  cp.key AS key,

  -- Map order details
  ROW(
    oc.orderId,
    oc.quantity,
    ip.price,
    oc.discountPercent
  ) AS orderDetails,

  -- Map customer details
  ROW(
    CAST(cp.key as STRING),
    cp.name,
    cp.membership,
    cp.creditCardNumber,
    cp.shippingAddress,
    cp.directSubscription,
    cp.birthday
  ) AS customerDetails,

  -- Map item details
  ROW(
    CAST(ip.key AS STRING),
    ip.name,
    ip.description
  ) AS itemDetails

FROM
  `shadowtraffic.order.created` AS oc

-- Join to customer profile
INNER JOIN
  `shadowtraffic.customer.profile` AS cp
  ON oc.customerId = CAST(cp.key AS STRING)

-- Join to item profile
INNER JOIN
  `shadowtraffic.item.profile` AS ip
  ON oc.itemId = CAST(ip.key AS STRING);