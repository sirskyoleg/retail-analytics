-- src/pipelines/bronze/ingest_customers.sql
-- Bronze layer: Raw data ingestion from source

CREATE OR REFRESH STREAMING LIVE TABLE customers_raw
COMMENT "Raw customer data from source system"
AS SELECT 
  customer_id,
  first_name,
  last_name,
  email,
  phone,
  address,
  city,
  state,
  country,
  postal_code,
  created_at,
  updated_at,
  _metadata.*
FROM STREAM(
  read_files(
    '/path/to/raw/customers/*.json',
    format => 'json',
    multiLine => 'false'
  )
);