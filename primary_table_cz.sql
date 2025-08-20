DROP TABLE IF EXISTS t_marek_prochazka_project_SQL_primary_final;
CREATE TABLE t_marek_prochazka_project_SQL_primary_final AS
WITH avg_food_price AS (
	SELECT
		c2.name AS item,
		extract(YEAR FROM c.date_from) AS year,
		round(avg(c.value)::NUMERIC,2) AS avg_price
	FROM czechia_price c
	JOIN czechia_price_category c2
		ON c.category_code = c2.code
	GROUP BY c2.name, extract(YEAR FROM c.date_from)
),
avg_wage AS (
	SELECT
		c2.name AS industry,
		c.payroll_year AS year,
		round(avg(c.value)::NUMERIC,0) AS avg_salary
	FROM czechia_payroll c
	JOIN czechia_payroll_industry_branch c2
		ON c.industry_branch_code = c2.code
	WHERE c.value IS NOT NULL
		AND c.calculation_code = 200
		AND c.value_type_code = 5958
		AND payroll_year < 2021
	GROUP BY c2.name, c.payroll_year
),
common_years AS (
	SELECT
		year
	FROM avg_food_price
	INTERSECT
	SELECT
		year
	FROM avg_wage
)
SELECT
	year,
	item,
	NULL::text AS industry,
	avg_price,
	NULL::NUMERIC AS avg_salary,
	'category' AS row_type
FROM avg_food_price
WHERE year IN(
	SELECT
		year
	FROM common_years)
UNION ALL
SELECT
	year,
	NULL::text AS item,
	industry,
	NULL::NUMERIC AS avg_price,
	avg_salary,
	'industry' AS row_type
FROM avg_wage
WHERE year IN (
	SELECT
		year
	FROM common_years);