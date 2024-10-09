-- FCE COUNT()
-- Úkol 1: Spočítejte počet řádků v tabulce czechia_price.

SELECT COUNT(1) AS number_of_rows
FROM czechia_price cFp;
-- Úkol 2: Spočítejte počet řádků v tabulce czechia_payroll s konkrétním sloupcem jako argumentem funkce COUNT().

SELECT COUNT(id) AS number_of_rows_in_column
FROM czechia_payroll cp;
-- fce count počítá jen ty řádky, kde je uložena nějaká hodnota, ignoruje to null hodnoty
-- spočítej počet řádků ve sloupci id, kdyby tam byla 1, tak je výstup stejný, ale kdyby tam byla nulová hodnota, tak je to problém
-- když tam dám 1 = on udělá jakoby nový sloupec a pro každý řádek a dá do hodnoty 1 a ty pak sečte, proto je to optimálnější je to nenáročné na výpočetní kapacitu.

SELECT COUNT(value) AS number_of_rows_in_column
FROM czechia_payroll cp;

-- Úkol 3: Z kolika záznamů v tabulce czechia_payroll jsme schopni vyvodit průměrné počty zaměstnanců?

SELECT COUNT (id) AS number_of_employees
FROM czechia_payroll cp
WHERE
	value_type_code  = 316 AND 
	value IS NOT NULL;

SELECT *
FROM czechia_payroll_value_type;

-- Úkol 4: Vypište všechny cenové kategorie a počet řádků každé z nich v tabulce czechia_price.

-- Úkol 5: Rozšiřte předchozí dotaz o dadatečné rozdělení dle let měření.

-- Funkce SUM()
-- Úkol 1: Sečtěte všechny průměrné počty zaměstnanců v datové sadě průměrných platů v České republice.

SELECT SUM(value) AS value_sum
FROM czechia_payroll cp
WHERE value_type_code = 316;

-- Úkol 2: Sečtěte průměrné ceny pro jednotlivé kategorie pouze v Jihomoravském kraji.
-- nejdřív se podíváme zase na data

SELECT *
FROM czechia_price cp 
LIMIT 10;

SELECT
	SUM(value) AS sum_of_avg_prices,
	category_code 
FROM czechia_price cp 
WHERE region_code ='CZ064' -- Jihomoravscký kraj (číselník czechia_region)
GROUP BY category_code;
-- select dám pro ty proměnné, co chci mít nahoře v tabulce
-- pozor na agregace - jakmile seskupuji, tak musím použít GROUP BY

-- Úkol 3: Sečtěte průměrné ceny potravin za všechny kategorie, u kterých měření probíhalo od (date_from) 15. 1. 2018.

SELECT
	category_code,
	SUM(value) AS sum_of_avg_prices_2018
FROM czechia_price cp 
WHERE date_from = '2018-01-15' -- yyyy-mm-dd
GROUP BY category_code;

SELECT
	SUM(value) AS sum_of_avg_prices_2018
FROM czechia_price cp 
WHERE CAST(date_from AS DATE) = '2018-01-15'; -- všechny záznamy po tom datu: >= '2018-01-15'
-- V tomto rozhraní ten CAST nepotřebuji, protože to samo pozná, že to je datum, ale někde je to třeba specifikovat

-- Další agregační funkce
-- Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.

SELECT MAX(value) AS max_value
FROM czechia_payroll cp;

-- Úkol 2: Na základě údajů v tabulce czechia_price vyberte pro každou kategorii potravin její minimum v letech 2015 až 2017.

SELECT
	category_code,
	YEAR (date_from),
	MIN(value) AS min_value
FROM czechia_price cp
WHERE YEAR (date_from) BETWEEN 2015 AND 2017
GROUP BY category_code;

SELECT YEAR (date_from)
FROM czechia_price cp;

-- Úkol 3: Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.

SELECT *
FROM czechia_payroll_industry_branch
WHERE code IN (
	SELECT industry_branch_code
	FROM czechia_payroll
	WHERE value IN (
		SELECT MAX(value)
		FROM czechia_payroll
		WHERE value_type_code = 5958
)
);

-- 

