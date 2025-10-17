# DataLens Dataset — связи и calculated fields

## Источники
- `fact_enriched` (03_fact_enriched.sql) — факт: dt, client_id, category, sku, net_revenue, margin_amt
- `plans_norm` (04_plans_norm.sql) — план: dt, manager_id, category, sku, revenue_plan, margin_plan, avg_check_plan
- `dim_clients` (05_dim_clients.sql) — client_id → manager_id
- `dim_employees` (06_dim_employees.sql) — employee_id, employee_name
- `dim_teams` (07_dim_teams.sql) — team_id, employee_id, member_role, lead_id
- `nomenclature` — sku, category, cost

## Джоины
- fact_enriched.client_id → dim_clients.client_id (LEFT)
- fact_enriched.sku → nomenclature.sku (LEFT)
- dim_clients.manager_id → dim_employees.employee_id (LEFT)
- dim_teams.employee_id → dim_employees.employee_id (LEFT)  (для ролей и иерархий)
- plans_norm: dt+category+sku (+manager_id через dim_clients) для сопоставления к факту

## Calculated fields (примеры)
- **NET_REVENUE** = sum([net_revenue])
- **MARGIN** = sum([margin_amt])
- **REVENUE_PLAN** = sum([revenue_plan])
- **MARGIN_PLAN** = sum([margin_plan])
- **AVG_CHECK_FACT** = sum([net_revenue]) / countDistinct([client_id])
- **AVG_CHECK_PLAN** = sum([avg_check_plan])
- **REVENUE_PCT** = if(REVENUE_PLAN = 0, NULL, NET_REVENUE / REVENUE_PLAN)
- **MARGIN_PCT** = if(MARGIN_PLAN = 0, NULL, MARGIN / MARGIN_PLAN)

## Ролевые фильтры
- Менеджер: фильтр по [manager_id] = текущий пользователь (или список привязанных id).
- Руководитель: фильтр по [lead_id] = текущий пользователь; при этом выбираются все [employee_id] из его команд.

## Полезные источники для чарта «Факт vs План»
- Ось X: [dt] (день/неделя/месяц)
- Серии: NET_REVENUE, REVENUE_PLAN  (аналогично для MARGIN/MARGIN_PLAN)

## Таблицы
- «Лига менеджеров» (для руководителя): строки — employee_name; метрики — NET_REVENUE, MARGIN, REVENUE_PCT
- «Клиенты и показатели» (для менеджера): строки — client_name; метрики — NET_REVENUE, MARGIN, AVG_CHECK_FACT
