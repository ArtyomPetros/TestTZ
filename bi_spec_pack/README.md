# BI-Пакет: Менеджер/Руководитель — План/Факт
Версия: 1.0

В пакете — всё, чтобы проверить и воспроизвести дашборды из задания:
1) **SQL-вьюхи** для расчёта показателей (факт/план, маржа, средний чек, категория, артикула).
2) **Спецификация DataLens Dataset**: calculated fields и связи.
3) **Чек-лист визуализаций**: что и как отрисовать для роли менеджера и руководителя.
4) **Схема данных (инференс из CSV)**.

## Состав исходных CSV
- `clients.csv`: колонки — ['client_id', 'legal_name', 'inn', 'employee_id']
- `employees.csv`: колонки — ['employee_id', 'fio', 'role']
- `nomenclature.csv`: колонки — ['sku', 'category', 'price']
- `orders.csv`: колонки — ['order_id', 'order_date', 'client_id', 'sku', 'amount_by_sku', 'margin_by_sku']
- `plans.csv`: колонки — ['plan_id', 'period_start', 'period_end', 'employee_id', 'plan_revenue', 'plan_margin']
- `sales.csv`: колонки — ['sale_id', 'sale_date', 'client_id', 'sku', 'sale_amount_by_sku']
- `sales_adjustments.csv`: колонки — ['adj_id', 'adj_date', 'client_id', 'sku', 'return_amount_by_sku']
- `teams.csv`: колонки — ['team_id', 'employee_id', 'role', 'lead_id']

## Как предоставить результат заказчику
- Отправить **zip** с этим пакетом + ссылку на **Git-репозиторий**.
- В письме: краткий отчёт (что реализовано) и скриншоты дашбордов.
- (Опционально) Ссылка на опубликованные дашборды DataLens с доступом "просмотр".
