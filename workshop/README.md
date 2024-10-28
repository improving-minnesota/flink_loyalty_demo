# Workshop
---

All required resources in Confluent Cloud must be already created for this lab to work correctly. If you haven't already, please follow the [prerequisites](prereq.md).

----

## Contents of the Lab
[1. Verify Confluent Cloud Resources](README.md#1-verify-confluent-cloud-resources)

[2. Connecting to Flink ](README.md#2-connecting-to-flink)

[3. Data Transformation](README.md#3-data-tranformation)

[4. Data Enrichment](README.md#4-data-enrichment)

[5. Loyalty Level Calculations](README.md#5-loyalty-level-calculations)

[6. Promotions Calcualations](README.md#6-promotions-calculations)

----

## 1. Verify Confluent Cloud Resources
Let's verify if all resources were created correctly and we can start using them.

### Kafka Topics
Check if the following topics exist in your Kafka cluster:
 * raw_products (for product data aka Product Catalog),
 * datagen_customers (for customer data aka Customer CRM),
 * datagen_orders (for realtime order transactions aka Order Processing System).

### Schemas in Schema Registry
Check if the following Avro schemas exist in your Schema Registry:
 * products-value,
 * customers-value,
 * orders-value.

NOTE: Schema Registry is at the Environment level and can be used for multiple Kafka clusters.

### Datagen Connectors
Your Kafka cluster should have two Source Connectors.

| Connector Name (can be anything)     |      Topic(s)      | Format 
|--------------------------------------|:---------------:|-------:|
| **order_source**    |   datagen_orders   | AVRO | 
| **customer_source**    |   datagen_customers   | AVRO | 

## 2. Connecting to Flink 
You can use your web browser or console to enter Flink SQL statements.
  * **Web UI** - from the Home page click on the `Stream Processing` on the left side navigation
    Select your workspace or click button 'Create workspace' to create a new one

  * **Console** - copy/paste the command from your Flink Compute Pool to the command line.    
  Of course you could also use the the Flink SQL Shell. For this, you need to have Confluent Cloud Console tool installed and be logged in with correct access rights.
  Copy the command out of the Compute Pool Window and execute it in your terminal (we prefer iterm2). 
  ```bash
  confluent flink shell --compute-pool <pool id> --environment <env-id>
  ```

NOTE: You can also access your Flink Compute Pool from the Data Portal as shown below. Just click on `Data Portal` in the main menu on the left side. Then select your Environment. You should see your topics. When you click on any of the topic tiles you can query the topic's data using Flink. 

Data Portal: `orders` topic selected. Click on `Query` button to access your Flink Compute Pool.
![image](../assets/dataPortal.png)

## 3. Data Transformation
Our product data is coming in from a source database in a raw JSON format.  Look at the product data in the topic. (Data Portal or Flink Statement) 

```
SELECT CAST(rp.val as STRING) FROM raw_products rp;
```

This obviously will not be easy to work with.  Let's leverage Flink to transform this raw format into our desired `product` schema.

```
SELECT 
  CAST(JSON_VALUE(product_json, '$.id') as BYTES) as key,
  JSON_VALUE(product_json, '$.id') as id,
  JSON_VALUE(product_json, '$.name') as product_name,
  JSON_VALUE(product_json, '$.product_type') as product_type,
  CAST(JSON_VALUE(product_json, '$.sale_price') as INT) as sale_price
FROM 
  (  
    SELECT 
      CAST(rp.val as STRING) as product_json
    FROM `raw_products` rp
  );
```

Verify the data looks right, then we will push it to a new table and topic! 

> [01-Product_Transformation.sql](01-Product_Transformation.sql)

Verify the data is making to to the `products` topic.

```
SELECT * FROM products;
```

## 4. Data Enrichment  
Now that we have that cleaned up, let's put the data to use!  We will join data from: Order, Customer, Product tables together in a single SQL statement.

> [03-Order_Enrichment.sql](03-Order_Enrichment.sql)

Verify the data was joined successfully!

```
SELECT * FROM order_customer_product;
```

## 5. Loyalty Level Calculations
Now we are ready to calculate loyalty levels for our customers.  Your team has decided to create 4 levels of pizza shop loyalty.  GOLD, SILVER, BRONZE, and CLIMBING.  The levels will coincide to a customer's TOTAL SPEND in their lifetime as a customer.

Let's get a feel for the data (explore lifetime spends)

```
SELECT
  email,
  SUM(sale_price) AS total_spend
FROM order_customer_product
GROUP BY email;
```

Let's build our loyalty levels base on this data.

```
SELECT
  email,
  SUM(sale_price) AS total,
  CASE
    WHEN SUM(sale_price) > 50000 THEN 'GOLD'
    WHEN SUM(sale_price) > 10000 THEN 'SILVER'
    WHEN SUM(sale_price) > 2500 THEN 'BRONZE'
    ELSE 'CLIMBING'
  END AS rewards_level
FROM order_customer_product
GROUP BY email;
```
> NOTE:  You can adjust the dollar amounts depending how long you have been pushing order data.


That looks good!  Let's create and populate the `loyalty_levels` table:

> [04-Loyalty_Level_Calculations.sql](04-Loyalty_Level_Calculations.sql)


## 6. Promotions Calcualations
Promotions are great! Customers LOVE free stuff!  Let's build a few:

But first, let's build our `promotions` table:

> [05-Promotions_Table.sql](05-Promotions_Table.sql)


#### Promotion 1 - Buy 6 Pizzas, Get 1 FREE
People love to eat their favorite pizza, but you know what they love even more???  Getting their favorite pizza for FREE! Let's build a promotion that looks tells us when a customer reaches their 6th purchase!

Look into the data:

```
SELECT
   email,
   COUNT(*) AS total,
   (COUNT(*) % 6) AS sequence,
   (COUNT(*) % 6) = 0 AS next_one_free
 FROM order_customer_product
 WHERE product_type = 'Pizza'
 GROUP BY email;
```
> NOTE:  Order generation data is random.  You might need to select a different puchase count to get promotions to show up. 

Our promotion engine only needs to know the email and the name of the promotion.  It will look up the notification and verbage to send in another system.  So we don't need to have a customer's "journey" towards the promotion, just the ones that have activated the promotion.  We can do that!

> [06-Promo1.sql](06-Promo1.sql)

#### Promotion 2 - BUNDLE UP
Let's put together another promotion.  This one will trigger after someone has bought a Drink and a Detroit Style Pizza.

```
INSERT INTO promotions
SELECT
     email,
     'PROMO-BUNDLE-1' AS promotion_name
  FROM order_customer_product
  WHERE product_type IN ('Drinks', 'Detroit-Style Pizza')
  GROUP BY email
  HAVING COUNT(DISTINCT product_type) = 2;

```

Let's now look at what we have going on in the promotions table:

```
SELECT * FROM promotions;
```

#### Promotion 3 - ???
Think of something else?  Want to explore?  Let's do it!!
