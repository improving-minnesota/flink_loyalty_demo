# FlinkSQL Notes

Useful Links -
- [DDL Statements in Confluent Cloud for Apache Flink](https://docs.confluent.io/cloud/current/flink/reference/statements/overview.html)
- [Metadata Columns](https://docs.confluent.io/cloud/current/flink/reference/statements/create-table.html#flink-sql-metadata-columns)
- [SQL Functions](https://docs.confluent.io/cloud/current/flink/reference/functions/overview.html#flink-sql-functions-overview)
- [SQL Operators](https://docs.confluent.io/cloud/current/flink/reference/functions/comparison-functions.html#flink-sql-comparison-and-equality-functions)
- [Joins Docs](https://www.confluent.io/blog/getting-started-with-apache-flink-sql/#joins)

## Sample Commands

### Show/Describe

```shell
# prints > catalogs (environments)
SHOW CATALOGS;

# prints > databases (clusters)
SHOW DATABASES;

# prints > tables (topics)
SHOW TABLES;

# prints > tables (topics) with prefix
SHOW TABLES LIKE 'shadow%';
SHOW TABLES NOT LIKE 'shadow%';

# prints > create table statement
SHOW CREATE TABLE `shadowtraffic.customer.profile`;

# prints > column name, type, nullable, extras
DESCRIBE `shadowtraffic.customer.profile`;
```

### Alter Tables (Topics)

Confluent creates tables for every topic by default. They don't have certain metadata by default though.

To make metadata like partition, offset, headers, topic, and timestamp to the table, run the ALTER below with only the columns you want to add.

```shell
# add metadata column(s) to table
ALTER TABLE `shadowtraffic.customer.profile` ADD (
  `partition` BIGINT METADATA VIRTUAL,
  `offset` BIGINT METADATA VIRTUAL,
  `headers` MAP<BYTES,BYTES> METADATA VIRTUAL,
  `topic` STRING METADATA VIRTUAL,
  `event_time` TIMESTAMP_LTZ(3) METADATA FROM 'timestamp'
);
```

### Joins

```roomsql
-- view results
SELECT * 
  FROM `shadowtraffic.customer.profile` AS cp
  INNER JOIN `shadowtraffic.order.created` AS oc
  ON CAST(cp.key AS STRING) = oc.customerId
  LIMIT 10;

-- send results to topic
INSERT INTO `shadowtraffic.customerorder.created`
SELECT 
  -- CAST(null AS BYTES) AS key, -- tombstone
  cp.key as key,
  cp.name as name,
  oc.orderId as orderId,
  oc.customerId as customerId
FROM 
  `shadowtraffic.customer.profile` AS cp
INNER JOIN 
  `shadowtraffic.order.created` AS oc
ON 
  CAST(cp.key AS STRING) = oc.customerId;
```