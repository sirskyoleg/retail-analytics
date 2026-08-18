-- src/pipelines/silver/clean_customers.sql
-- Silver layer: Cleaned and validated customer data

CREATE OR REFRESH STREAMING LIVE TABLE customers (
  CONSTRAINT valid_email EXPECT (email IS NOT NULL AND email LIKE '%@%') ON VIOLATION DROP ROW,
  CONSTRAINT valid_customer_id EXPECT (customer_id IS NOT NULL) ON VIOLATION FAIL UPDATE
)
COMMENT "Cleaned customer data with data quality checks"
AS SELECT 
  customer_id,
  INITCAP(TRIM(first_name)) as first_name,
  INITCAP(TRIM(last_name)) as last_name,
  CONCAT(first_name, ' ', last_name) as name,
  LOWER(TRIM(email)) as email,
  REGEXP_REPLACE(phone, '[^0-9]', '') as phone,
  TRIM(address) as address,
  TRIM(city) as city,
  UPPER(TRIM(state)) as state,
  UPPER(TRIM(country)) as country,
  postal_code,
  created_at,
  updated_at,
  CURRENT_TIMESTAMP() as processed_at
FROM STREAM(LIVE.customers_raw)
WHERE customer_id IS NOT NULL;