# 🚀 Retail Analytics - Databricks Asset Bundle

## Опис проекту

Цей проект містить повну інфраструктуру для аналітики роздрібної торгівлі на Databricks:

* **Bronze/Silver/Gold Tables**: Medallion architecture для обробки даних
* **Delta Live Tables Pipeline**: Автоматизований data pipeline
* **Genie Space**: AI-асистент для природномовних запитів українською/англійською
* **CI/CD Pipeline**: Автоматичний deploy через GitHub Actions

---

## 🛠️ Передумови

1. **Databricks Workspace** (AWS/Azure/GCP)
2. **Unity Catalog** ввімкнений
3. **Databricks CLI** встановлений
4. **GitHub Account** для CI/CD

---

## 💻 Локальний Deploy

### 1. Встановіть Databricks CLI

```bash
pip install databricks-cli
```

### 2. Налаштуйте автентифікацію

```bash
databricks configure --token
```

### 3. Валідуйте конфігурацію

```bash
databricks bundle validate -t dev
```

### 4. Deploy на dev

```bash
databricks bundle deploy -t dev
```

### 5. Запустіть pipeline

```bash
databricks bundle run retail_pipeline -t dev
```

### 6. Deploy Genie Space

```bash
cd src/genie
python deploy_genie_space.py --env dev
```

---

## 🚀 Production Deploy через CI/CD

### 1. Налаштуйте GitHub Secrets

У вашому GitHub репозиторії, додайте:

* `DATABRICKS_HOST` - URL вашого prod workspace
* `DATABRICKS_TOKEN` - Service Principal token

### 2. Push до main branch

```bash
git add .
git commit -m "Deploy retail analytics"
git push origin main
```

Або запустіть вручну через GitHub Actions UI.

---

## 📊 Gold Tables

### customer_service_summary
Зведена статистика по категоріям звернень до служби підтримки:
* issue_category
* total_records
* avg_satisfaction
* resolved_count
* pending_count

### product_wise_revenue
Загальна виручка по кожному продукту:
* product_name
* revenue
* total_quantity_sold
* unique_customers

### top_customers
Клієнти з найбільшими витратами:
* customer_id
* name
* total_spent
* total_orders
* avg_order_value

---

## 🤖 Genie Space

Після deploy ви можете:

* Задавати питання **українською** або **англійською**
* Отримувати інсайти з 3 gold таблиць
* Використовувати benchmark для перевірки якості

**Приклади питань:**
* “Які топ-5 клієнтів за виручкою?”
* “Яка середня оцінка обслуговування?”
* “Show me the most profitable products”

---

## 🔧 Трублшутинг

### Pipeline помилки

```bash
# Перевірте логи
databricks pipelines get --pipeline-id <pipeline_id>
```

### Genie Space не створено

Перевірте:
1. Чи існують gold таблиці
2. Чи правильні permissions
3. Чи коректна конфігурація в config.yaml

---

## 📚 Документація

* [Databricks Asset Bundles](https://docs.databricks.com/dev-tools/bundles/)
* [Delta Live Tables](https://docs.databricks.com/delta-live-tables/)
* [Genie Spaces](https://docs.databricks.com/en/genie/)
* [Unity Catalog](https://docs.databricks.com/data-governance/unity-catalog/)

---

## ✉️ Контакти

Питання чи проблеми? Створіть GitHub Issue!