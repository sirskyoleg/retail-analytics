-- src/pipelines/gold/product_wise_revenue.sql
-- Gold layer: Виручка по продуктах

CREATE OR REFRESH LIVE TABLE product_wise_revenue
COMMENT "Загальна виручка по кожному продукту"
AS
SELECT 
  p.product_name,
  p.product_id,
  SUM(o.quantity * o.unit_price) as revenue,
  SUM(o.quantity) as total_quantity_sold,
  COUNT(DISTINCT o.order_id) as total_orders,
  COUNT(DISTINCT o.customer_id) as unique_customers,
  AVG(o.unit_price) as avg_unit_price
FROM LIVE.orders o
INNER JOIN LIVE.products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.product_id
ORDER BY revenue DESC;