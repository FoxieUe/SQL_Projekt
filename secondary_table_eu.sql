DROP TABLE IF EXISTS t_marek_prochazka_project_SQL_secondary_final;
CREATE TABLE t_marek_prochazka_project_SQL_secondary_final AS
WITH europe AS (
	SELECT
		*
	FROM countries
	WHERE continent = 'Europe'
)
SELECT DISTINCT 
	ec.year,
	ec.country,
	e.capital_city,
	ec.gdp,
	e.currency_name,
	e.currency_code,
	ec.population,
	e.population_density,
	ec.gini,
	ec.taxes
FROM economies ec
JOIN europe e
	ON ec.country = e.country
ORDER BY ec.country, ec.year;