-------------
-- CREATE TABLE
-------------

-- Create a promotions table.

CREATE TABLE promotions(
  email STRING,
  promotion_name STRING,
  PRIMARY KEY (email) NOT ENFORCED
);
