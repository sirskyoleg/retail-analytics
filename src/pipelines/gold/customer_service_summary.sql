-- src/pipelines/gold/customer_service_summary.sql
-- Gold layer: Агрегована статистика по обслуговуванню клієнтів

CREATE OR REFRESH LIVE TABLE customer_service_summary
COMMENT "Зведена статистика по категоріям звернень до служби підтримки"
AS 
SELECT 
  issue_category,
  COUNT(*) as total_records,
  AVG(CAST(satisfaction_score AS DOUBLE)) as avg_satisfaction,
  COUNT(CASE WHEN status = 'resolved' THEN 1 END) as resolved_count,
  COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_count,
  AVG(DATEDIFF(resolved_at, created_at)) as avg_resolution_days
FROM LIVE.customer_service_request
WHERE issue_category IS NOT NULL
GROUP BY issue_category;