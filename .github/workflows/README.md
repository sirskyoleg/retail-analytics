# CI/CD Setup Instructions

## GitHub Actions Workflows

Цей проект містить три автоматизовані workflows:

### 1. **Deploy to Production** (`deploy-prod.yml`)
- **Тригер**: Push в `main` branch або manual trigger
- **Що робить**: 
  - Валідує bundle
  - Deploy в production workspace
  - Опціонально запускає pipeline

### 2. **Deploy to Development** (`deploy-dev.yml`)
- **Тригер**: Push в `dev` branch або Pull Request в `main`
- **Що робить**: 
  - Валідує bundle
  - Deploy в development workspace

### 3. **Validate Bundle** (`validate.yml`)
- **Тригер**: Pull Request в `main` або `dev`
- **Що робить**: Перевіряє синтаксис bundle

## Налаштування GitHub Secrets

### Крок 1: Створіть Personal Access Tokens для кожного workspace

#### Development Workspace Token:
1. Перейдіть до вашого Dev workspace: https://dbc-9e376111-e24d.cloud.databricks.com
2. User Settings → Developer → Access tokens
3. Generate new token (назва: "GitHub Actions Dev")
4. Скопіюйте token

#### Production Workspace Token:
1. Перейдіть до вашого Prod workspace (URL вашого production workspace)
2. User Settings → Developer → Access tokens
3. Generate new token (назва: "GitHub Actions Prod")
4. Скопіюйте token

### Крок 2: Додайте Secrets в GitHub

1. Перейдіть до вашого репозиторію: https://github.com/sirskyoleg/retail-analytics
2. Settings → Secrets and variables → Actions
3. Натисніть **"New repository secret"**

Додайте наступні secrets:

#### For Development:
- **Name**: `DEV_DATABRICKS_HOST`
  - **Value**: `https://dbc-9e376111-e24d.cloud.databricks.com`

- **Name**: `DEV_DATABRICKS_TOKEN`
  - **Value**: (ваш dev token з Кроку 1)

#### For Production:
- **Name**: `PROD_DATABRICKS_HOST`
  - **Value**: (URL вашого production workspace, наприклад `https://adb-1234567890123456.7.azuredatabricks.net`)

- **Name**: `PROD_DATABRICKS_TOKEN`
  - **Value**: (ваш prod token з Кроку 1)

### Крок 3: Оновіть databricks.yml

Відредагуйте `databricks.yml` та вкажіть правильний production workspace URL:

\`\`\`yaml
targets:
  prod:
    workspace:
      host: https://your-actual-prod-workspace.cloud.databricks.com  # ← Замініть на реальний URL
\`\`\`

### Крок 4: Commit & Push

\`\`\`bash
git add .github/
git commit -m "Add CI/CD workflows"
git push origin main
\`\`\`

## Використання

### Автоматичний Deploy в Production
Просто push в `main` branch:
\`\`\`bash
git push origin main
\`\`\`

### Manual Deploy з запуском Pipeline
1. Перейдіть до GitHub → Actions
2. Оберіть "Deploy to Production"
3. Натисніть "Run workflow"
4. Оберіть "Run pipeline after deployment: true"
5. Натисніть "Run workflow"

### Deploy в Development
\`\`\`bash
git checkout -b dev
git push origin dev
\`\`\`

## Перевірка статусу

Після push перейдіть до:
https://github.com/sirskyoleg/retail-analytics/actions

Тут ви побачите статус всіх запущених workflows.

## Troubleshooting

### Помилка: "Invalid token"
- Перевірте що токени в GitHub Secrets правильні
- Токени мають права: `workspace_access`, `clusters`, `pipelines`

### Помилка: "Bundle validation failed"
- Перевірте синтаксис `databricks.yml`
- Запустіть локально: `databricks bundle validate --target prod`

### Помилка: "Workspace not found"
- Перевірте що `DATABRICKS_HOST` в secrets правильний
- URL має бути повним: `https://...`

## Optional: Service Principal (Рекомендовано для Production)

Замість особистих токенів, використовуйте Service Principal:

1. Створіть Service Principal в Azure/AWS/GCP
2. Додайте його в Databricks workspace
3. Оновіть `databricks.yml`:
   \`\`\`yaml
   prod:
     run_as:
       service_principal_name: "sp-retail-analytics-prod"
   \`\`\`
4. Оновіть GitHub secrets на Service Principal credentials
