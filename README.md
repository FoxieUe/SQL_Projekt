# Průvodní listina k SQL projektu

## Vstupní tabulky

### t\_marek\_prochazka\_project\_SQL\_primary\_final

* Jsme vytvořili spojením tabulek **czechia\_price**, **czechia\_price\_category**, **czechia\_payroll** a **czechia\_payroll\_industry\_branch**.
* Data zde byly sjednocena, aby obsahovali pouze roky pro které máme jak informace o potravinách tak mzdách přesnějí **2006-2018**.
* Tabulku je možné filtrovat pomocí **row\_type** na část obsahující potraviny(**category**) nebo část obsahující mzdy(**industry**).
* Sloupce v tabulce:
  \* **year** - rok
  \* **item** - potravina
  \* **industry** - odvětví
  \* **avg\_price** - průměrná cena
  \* **avg\_salary** - průměrná mzda
  \* **row\_type** - kategorie

### t\_marek\_prochazka\_project\_SQL\_secondary\_final

* Jsme vytvořili spojením tabulek **countries**, **economies**.
* Data zde byly filtrována tak, aby obsahovala jen informace o **Evropě**.
* Sloupce v tabulce:
  \* **year** - rok
  \* **country** - země
  \* **capital\_city** - hlavní město
  \* **gdp** - HDP
  \* **currency\_name** - název měny
  \* **currency\_code** - kód měny
  \* **population** - populace
  \* **population\_density** - hustota zalidnění
  \* **gini** - gini
  \* **taxes** - daňové zatížení
* Pro projekt byly poté už využity jen informace za **Českou republiku**.



## Výzkumné otázky a mezivýsledky

### 1\. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Dotaz SQL sleduje trend mezd ve sledovaném období **2006-2018** pro jednotlivá odvětví.
Výsledek ukazuje, že ve **všech odvětvích mzdy rostou**, v některých dojde ke krátkodobému poklesu, ale stale je trend převážne rostoucí.
Některá odvětví vykazují růst ve všech letech.



### 2\. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?

Dotaz SQL porovnává průměrnou mzdu s cenami mléka a chleba v prvním a posledním roce roce a to přesnějí \**2006* a **2018**.
Výsledek ukazuje, že za průměrnou mzdu si lze koupit výrazně více kusů než v počátečním období.



### 3\. Která kategorie potravin zdražuje nejpomaleji?

Dotaz SQL sleduje **průměrný meziroční procentní nárůst** cen u jednotlivých potravin kde **došlo ke zdražení minimálně 6x**.
Výsledek ukazuje ,že nejnižší průměrný růst vykazuje **Pivo výčepní, světlé, lahvové**, což znamená, že tato položka **zdražuje nejpomaleji**.

### 4\. Existuje rok, ve kterém byl růst cen potravin výrazně vyšší než růst mezd (> 10 %)?

Dotaz SQL počítá **meziroční rozdíl v procentech mezi cenami a mzdami** .
Výsledek ukazuje, že ve sledovaném období **neexistuje rok**, kdy by byl **růst cen potravin vyšší než růst mezd o 10 %**.
**Nejblíže k tomu měl rok 2013** u kterého **rozdíl mezi růstem potravin a růstem mezd byl 6.66 %**.

### 5\. Má výška HDP vliv na změny ve mzdách a cenách potravin?

Dotaz SQL porovnává **meziroční změny HDP s růstem mezd a cen potravin ve stejném i následujícím roce**.
Výsledek ukazuje, že **vyšší růst HDP je obvykle provázen růstem mezd** a **často také růstem cen potravin**.
V letech **2007** a **2017** byl nejvíce **znatelný růst**.
Naopak oproti tomu například rok **2013** HDP **stagnovalo** a mzdy dokonce **klesly**.

## Informace o výstupních datech

* Výsledná data obsahuji **jen roky 2006-2018**, protože jen pro toto období jsou k dispozici jak informace o **mzdách**, **cen potravin**, tak i **hdp**.
* U některých výpočtů máme \**NULL hodnoty*:

  * **na začátku sloupce** když používáme **LAG()**, protože není předchozí hodnota
  * **na konci sloupce** když používáme **LEAD()**, protože není následující hodnota

* **Průměrnou mzdu** a **průměrnou cenu potravin** počítáme z dostupných tabulek za pomocí funkce **AVG()** .
