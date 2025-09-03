--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
WITH prices_lag AS (
	SELECT
		year,
		item,
		avg_price,
		lag(avg_price) OVER ( PARTITION BY item ORDER BY year) AS previous_price,
		LAG(year) OVER (PARTITION BY item ORDER BY year) AS previous_year
	FROM t_marek_prochazka_project_sql_primary_final
	WHERE row_type = 'category'
),
prices_lag_p AS (
	SELECT 
		year,
		item,
		avg_price,
		round(((avg_price - previous_price) / NULLIF(previous_price,0) * 100),2) AS percentage
	FROM prices_lag pl
	WHERE previous_price IS NOT NULL
		AND previous_year = year - 1
),
increases AS (
	SELECT
		*
	FROM prices_lag_p 
	WHERE percentage > 0
)
SELECT
  item AS polozka,
  ROUND(AVG(percentage), 2) AS prumerny_mezirociny_narust,
  COUNT(*) AS pocet_let_zdrazovani
FROM increases
GROUP BY item
HAVING COUNT(*) >= 6
ORDER BY prumerny_mezirociny_narust ASC
LIMIT 1;



