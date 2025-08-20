--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
WITH salary_year AS (
	SELECT
		year,
		avg(avg_salary) AS avg_salary_year
	FROM t_marek_prochazka_project_sql_primary_final tmppspf
	WHERE row_type = 'industry'
	GROUP BY year
),
food_year AS (
	SELECT
		year,
		avg(avg_price) AS avg_food_price
	FROM t_marek_prochazka_project_sql_primary_final tmppspf
	WHERE row_type = 'category'
	GROUP BY year
),
yearly AS (
	SELECT
		fy.year,
		fy.avg_food_price,
		sy.avg_salary_year,
		lag(sy.avg_salary_year) OVER (ORDER BY fy.year) AS prev_salary,
		lag(fy.avg_food_price) OVER (ORDER BY fy.year) AS prev_food
	FROM food_year fy
	JOIN salary_year sy
		ON fy.year = sy.year
),
yoy AS (
	SELECT 
		year,
		round((avg_food_price - prev_food) / NULLIF(prev_food, 0) * 100, 2) AS yoy_food,
		round((avg_salary_year - prev_salary) / nullif(prev_salary, 0) * 100, 2) AS yoy_salary
	FROM yearly
	WHERE prev_food IS NOT NULL
		AND prev_salary IS NOT NULL
)
SELECT
	year AS rok,
	yoy_food AS mezirocni_rust_cen_pct,
	yoy_salary AS mezirocni_rust_mezd_pct,
	(yoy_food - yoy_salary) AS mezirocni_rozdil,
	CASE
		WHEN (yoy_food - yoy_salary) > 10 THEN 'ANO'
		ELSE 'NE'
	END AS vic_nez_o_10
	FROM yoy
ORDER BY rok, mezirocni_rozdil DESC;