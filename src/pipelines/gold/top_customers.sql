-- src/pipelines/gold/top_customers.sql
-- Gold layer: Топ клієнти за витратами

CREATE OR REFRESH LIVE TABLE top_customers
COMMENT "Клієнти з найбільшими витратами"
AS
SELECT 
  c.customer_id,
  c.name,
  c.email,
  SUM(o.quantity * o.unit_price) as total_spent,
  COUNT(DISTINCT o.order_id) as total_orders,
  AVG(o.quantity * o.unit_price) as avg_order_value,
  MAX(o.order_date) as last_order_date,
  DATEDIFF(CURRENT_DATE(), MAX(o.order_date)) as days_since_last_order
FROM LIVE.customers c
INNER JOIN LIVE.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email
HAVING total_spent > 0
ORDER BY total_spent DESC;