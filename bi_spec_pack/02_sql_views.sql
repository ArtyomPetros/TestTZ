
-- 01_net_revenue.sql
WITH sales AS (
  SELECT CAST(sale_date AS DATE) AS dt,
         sku AS sku,
         client_id AS client_id,
         SUM(amount) AS sales_amt
  FROM sales
  GROUP BY 1,2,3
),
returns AS (
  SELECT CAST(return_date AS DATE) AS dt,
         sku AS sku,
         client_id AS client_id,
         SUM(amount) AS return_amt
  FROM sales_adjustments
  GROUP BY 1,2,3
)
SELECT COALESCE(s.dt,r.dt) AS dt,
       COALESCE(s.sku,r.sku) AS sku,
       COALESCE(s.client_id,r.client_id) AS client_id,
       COALESCE(s.sales_amt,0) - COALESCE(r.return_amt,0) AS net_revenue
FROM sales s
FULL OUTER JOIN returns r
  ON s.dt=r.dt AND s.sku=r.sku AND s.client_id=r.client_id;

-- 02_orders_margin.sql
SELECT CAST(order_date AS DATE) AS dt,
       sku AS sku,
       client_id AS client_id,
       SUM(margin_amount) AS margin_amt
FROM orders
GROUP BY 1,2,3;

-- 03_fact_enriched.sql
WITH nr AS (
  SELECT * FROM net_revenue -- from 01
),
om AS (
  SELECT * FROM orders_margin -- from 02
)
SELECT nr.dt,
       nr.client_id,
       i.category AS category,
       nr.sku,
       nr.net_revenue,
       COALESCE(om.margin_amt,0) AS margin_amt
FROM nr
LEFT JOIN om
  ON om.dt=nr.dt AND om.sku=nr.sku AND om.client_id=nr.client_id
LEFT JOIN nomenclature i ON i.sku = nr.sku;

-- 04_plans_norm.sql
SELECT CAST(period_start AS DATE) AS dt,
       employee_id AS manager_id,
       category AS category,
       sku AS sku,
       SUM(plan_revenue) AS revenue_plan,
       SUM(plan_margin)  AS margin_plan,
       SUM(avg_check_plan) AS avg_check_plan
FROM plans
GROUP BY 1,2,3,4;

-- 05_dim_clients.sql
SELECT c.client_id AS client_id,
       c.client_name AS client_name,
       c.inn AS inn,
       c.employee_id AS manager_id
FROM clients c;

-- 06_dim_employees.sql
SELECT e.employee_id AS employee_id,
       e.fio AS employee_name
FROM employees e;

-- 07_dim_teams.sql
SELECT t.team_id AS team_id,
       t.employee_id AS employee_id,
       t.role AS member_role,
       t.lead_id AS lead_id
FROM teams t;
