--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
WITH added_prev_year AS(
	SELECT
		year,
		industry,
		avg_salary,
		lag(avg_salary) OVER (PARTITION by industry ORDER BY year) AS previous_year
	FROM t_marek_prochazka_project_SQL_primary_final
	WHERE row_type = 'industry'
),
salary_trend AS (
	SELECT
		year,
		industry,
		avg_salary,
		CASE 
			WHEN previous_year IS NULL THEN '-'
			WHEN avg_salary > previous_year THEN 'roste'
			WHEN avg_salary < previous_year THEN 'klesá'
			ELSE 'stagnace'
		END AS trend
	FROM added_prev_year apy
)
SELECT
	zacatek_obdobi,
	konec_obdobi,
	industry AS odvetvi,
	CASE 
		WHEN pocet_poklesu = 0 AND pocet_rustu > 0 THEN 'roste ve všech letech'
		WHEN pocet_rustu > pocet_poklesu THEN 'převážně roste'
		ELSE 'převážně klesá'
	END AS trend_obdobi,
	pocet_poklesu,
	pocet_rustu
FROM (
	SELECT
		MIN(year) AS zacatek_obdobi,
		MAX(year) AS konec_obdobi,
		industry,
		SUM((trend = 'roste')::int) AS pocet_rustu,
		SUM((trend = 'klesá')::int) AS pocet_poklesu
	FROM salary_trend
	GROUP BY industry
)
ORDER BY trend_obdobi DESC, odvetvi;


