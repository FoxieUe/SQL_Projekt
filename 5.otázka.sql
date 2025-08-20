--5.Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
WITH common_years AS (
	SELECT
		year
	FROM (
		SELECT DISTINCT year
		FROM t_marek_prochazka_project_SQL_primary_final
		INTERSECT
		SELECT DISTINCT year
		FROM t_marek_prochazka_project_SQL_secondary_final
		WHERE country LIKE 'Czech%'
	) x
),
salary_y AS (
	SELECT
		year,
		ROUND(AVG(avg_salary)::NUMERIC, 2) AS avg_y_sal
	FROM t_marek_prochazka_project_SQL_primary_final
	WHERE row_type = 'industry'
	GROUP BY year
),
salary_lag AS (
	SELECT
		year,
		avg_y_sal,
		LAG(avg_y_sal)  OVER (ORDER BY year) AS prev_salary,
		LEAD(avg_y_sal) OVER (ORDER BY year) AS next_salary
	FROM salary_y
),
salary_pct AS (
	SELECT
		year,
		avg_y_sal,
		prev_salary,
		next_salary,
		ROUND(((avg_y_sal - prev_salary) / NULLIF(prev_salary, 0) * 100)::NUMERIC, 2) AS salary_yoy_pct,
		LEAD(ROUND(((avg_y_sal - prev_salary) / NULLIF(prev_salary, 0) * 100)::NUMERIC, 2), 1)
			OVER (ORDER BY year) AS salary_yoy_next
	FROM salary_lag
),
food_y AS (
	SELECT
		year,
		ROUND(AVG(avg_price)::NUMERIC, 2) AS avg_y_food
	FROM t_marek_prochazka_project_SQL_primary_final
	WHERE row_type = 'category'
	GROUP BY year
),
food_lag AS (
	SELECT
		year,
		avg_y_food,
		LAG(avg_y_food)  OVER (ORDER BY year) AS prev_food,
		LEAD(avg_y_food) OVER (ORDER BY year) AS next_food
	FROM food_y
),
food_pct AS (
	SELECT
		year,
		avg_y_food,
		prev_food,
		next_food,
		ROUND(((avg_y_food - prev_food) / NULLIF(prev_food, 0) * 100)::NUMERIC, 2) AS food_yoy_pct,
		LEAD(ROUND(((avg_y_food - prev_food) / NULLIF(prev_food, 0) * 100)::NUMERIC, 2), 1)
			OVER (ORDER BY year) AS food_yoy_next
	FROM food_lag
),
gdp_y AS (
	SELECT
		year,
		gdp
	FROM t_marek_prochazka_project_SQL_secondary_final
	WHERE country LIKE 'Czech%'
),
gdp_lag AS (
	SELECT
		year,
		gdp,
		LAG(gdp) OVER (ORDER BY year) AS prev_gdp
	FROM gdp_y
),
gdp_pct AS (
	SELECT
		year,
		gdp,
		prev_gdp,
		ROUND(((gdp - prev_gdp) / NULLIF(prev_gdp, 0) * 100)::NUMERIC, 2) AS gdp_yoy_pct
	FROM gdp_lag
)
SELECT
    g.year AS rok,
    g.gdp_yoy_pct AS mezirocni_rust_hdp_pct,
    s.salary_yoy_pct AS mezirocni_rust_mezd_pct,
    f.food_yoy_pct AS mezirocni_rust_cen_pct,
    s.salary_yoy_next AS rust_mezd_nalsedujici_rok_pct,
    f.food_yoy_next AS rust_cen_nasledujici_rok_pct
FROM gdp_pct g
JOIN salary_pct s
    ON g.year = s.year
JOIN food_pct f
    ON g.year = f.year
JOIN common_years cy
    ON g.year = cy.YEAR
WHERE gdp_yoy_pct IS NOT NULL
  AND salary_yoy_pct IS NOT NULL
  AND food_yoy_pct IS NOT NULL
ORDER BY g.year;


