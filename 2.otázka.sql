--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
WITH first_last_y AS (
	SELECT
		MIN(year) AS first_year,
		MAX(year) AS last_year
	FROM t_marek_prochazka_project_sql_primary_final
),
year_salary AS (
	SELECT
		year,
		round(avg(avg_salary), 0) AS avg_salary_y
	FROM t_marek_prochazka_project_sql_primary_final
	WHERE row_type = 'industry'
		AND year IN (
			SELECT
				first_year
			FROM first_last_y
			UNION
			SELECT
				last_year
			FROM first_last_y 
		)
	GROUP BY year
),
items_year AS (
	SELECT 
		year,
		item,
		avg_price
	FROM t_marek_prochazka_project_sql_primary_final
	WHERE row_type = 'category'
		AND item IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
		AND year IN (
			SELECT
				first_year
			FROM first_last_y
			UNION
			SELECT
				last_year
			FROM first_last_y 
		)
)
SELECT 
	iy.year AS rok,
	iy.item AS polozka,
	iy.avg_price AS prumerna_cena,
	ys.avg_salary_y AS prumerna_mzda,
	ROUND(ys.avg_salary_y / iy.avg_price, 0) AS pocet_kusu_za_mzdu
FROM items_year iy
JOIN year_salary ys
	ON iy.year = ys.year
ORDER BY iy.item, iy.year;