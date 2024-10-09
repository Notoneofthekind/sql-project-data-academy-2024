-- INNER JOIN = JOIN = spojí se mi jen ty řádky, které mají spojovací obraz z druhé strany, je možné, že zahodíme některé řádky, které nejsdou napojit
-- LEFT OUTER JOIN = LEFT JOIN = vennův diagram - zahrnu všechny prvnky z levé/ první tabulky, ty řádky, z druhé tabulky, které nejdou spojit, tak se vyplní NULLy
-- RIGHT OUTER JOIN = nedává moc smysl to používat, používá se častěji LEFT JOIN
-- Entitně relační diagram - ER diagram
-- násobnost vazby - notace - plná kulička značí, že může tady být kód, který má 0-100 obrazů, ale kde není kulička, tam má právě jeden obraz
-- kosočtverec
-- symbol šipky indikuje cizí klíč
-- klíček značí primární klíč = tou hodnotou, která je tady, tak j eidentifikován každý řádek

-- Úkol 1: Spojte tabulky czechia_price a czechia_price_category. Vypište všechny dostupné sloupce.

SELECT *
FROM czechia_price
JOIN czechia_price_category
	ON czechia_price.category_code = czechia_price_category.code;

-- pozor na aliasy, pokud se tam jednou doplní, musím jej pak používat ve zbytku kódu

SELECT *
FROM czechia_price cp 
JOIN czechia_price_category cpc 
	ON cp.category_code  = cpc.code ;
	
Úkol 2: Předchozí příklad upravte tak, že vhodně přejmenujete tabulky a vypíšete ID a jméno kategorie potravin a cenu.

SELECT
	cp.id,
	cpc.name,
	cp.value
FROM czechia_price cp 
JOIN czechia_price_category cpc
	ON cp.category_code  = cpc.code ;
	
-- co je tečková notace/prefix tabulky - to je to cp. ped id/neme u SELECTU

-- Úkol 3: Přidejte k tabulce cen potravin i informaci o krajích ČR a vypište informace o cenách společně s názvem kraje.

SELECT
	cp.*,
	cr.name 
FROM czechia_price cp
LEFT JOIN czechia_region cr
	ON cp.region_code = cr.code ;

Úkol 5: K tabulce czechia_payroll připojte všechny okolní tabulky. Využijte ERD model ke zjištění, které to jsou.
-- v industry _branch code bych mohla mít i NULLy, protože tam je kosočtvrerec

SELECT count(1)
FROM czechia_payroll cp 
WHERE industry_branch_code IS NULL;

SELECT *
FROM czechia_payroll cp
JOIN czechia_payroll_value_type cpvt 
	ON cp.value_type_code = cpvt.code
JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code 
JOIN czechia_payroll_calculation cpc 
	ON cp.calculation_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib
	ON cp.industry_branch_code = cpib.code ;

-- Úkol 6: Přepište dotaz z předchozí lekce do varianty, ve které použijete JOIN

SELECT cpib.*
FROM czechia_payroll_industry_branch cpib
JOIN czechia_payroll cp 
	 ON cp.industry_branch_code = cpib.code 
WHERE cp.value_type_code = 5958
ORDER BY cp.value DESC
LIMIT 1;

-- Úkol 7: Spojte informace z tabulek cen a mezd (pouze informace o průměrných mzdách). Vypište z každé 
-- z nich základní informace, celé názvy odvětví a kategorií potravin a datumy měření, které vhodně naformátujete.

SELECT
	cpib.name industry_branch,
	cpc.name category_name,
	cpay.value average_salary,
	cpay. payroll_year,
	cp.value price,
	date_format(cp.date_from, '%d.%m,%Y'),
	date_format(cp.date_to, '%d.%m.%Y')
FROM czechia_price cp 
JOIN czechia_payroll cpay
	ON cpay.payroll_year = YEAR (cp.date_from)
LEFT JOIN czechia_payroll_industry_branch cpib
	ON cpay.industry_branch_code = cpib.code
LEFT JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
WHERE cpay.value_type_code = 5958;

-- Úkol 8: K tabulce healthcare_provider připojte informace o regionech a vypište celé názvy krajů
-- i okresů pro místa výkonu i sídla.

SELECT
	hp.name,
	cr.name region_name,
	cr2.name residence_region_name,
	cd.name district_name,
	cd2.name residence_district_name
FROM healthcare_provider hp 
JOIN czechia_region cr 
	ON hp.region_code = cr.code 
JOIN czechia_district cd 
	ON hp.district_code = cd.code
JOIN czechia_region cr2
	ON hp.residence_region_code = cr2.code
JOIN czechia_district cd2 
	ON hp.residence_district_code = cd2.code ;

-- 9. úkol - domácí úkol

-- Kartézský součin a CROSS JOIN
-- Úkol 1: Spojte tabulky czechia_price a czechia_price_category pomocí kartézského součinu.

SELECT *
FROM czechia_price cp, czechia_price_category cpc
WHERE cp.category_code = cpc.code;

-- Úkol 2: Převeďte předchozí příklad do syntaxe s CROSS JOIN.
SELECT *
FROM czechia_price cp
CROSS JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code;
   
-- úkol 3 - domácí úkol
-- Úkol 3: Vytvořte všechny kombinace krajů kromě těch případů, kdy by se v obou sloupcích kraje shodovaly.
-- Množinové operace
-- Úkol 1: Přepište následující dotaz na variantu spojení dvou separátních dotazů se selekcí pro každý kraj zvlášť.   

SELECT
	category_code,
	value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION ALL
SELECT
	category_code,
	value
FROM czechia_price
WHERE region_code = 'CZ010';

-- UNION filruje duplicity, a UNION ALL zachová duplicity

-- Úkol 2: Upravte předchozí dotaz tak, aby byly odstraněny duplicitní záznamy.
SELECT
	category_code,
	value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION
SELECT
	category_code,
	value
FROM czechia_price
WHERE region_code = 'CZ010';

-- Úkol 3: Sjednoťe kraje a okresy do jedné množiny. Tu následně seřaďte dle kódu vzestupně.
SELECT code, name
FROM czechia_region cr 
UNION
SELECT code, name
FROM czechia_district cd 
ORDER BY code;

-- nevalidní dotaz - databáze mě upozorní
SELECT code, name
FROM czechia_region cr 
UNION
SELECT name
FROM czechia_district cd 
ORDER BY code;

-- nevalidní dotaz - databáze mě neupozorní
SELECT code, name
FROM czechia_region cr 
UNION
SELECT name, code
FROM czechia_district cd 
ORDER BY code;

-- Úkol 4: Vytvořte průnik cen z krajů Hl. město Praha a Jihomoravský kraj.
SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ064'
INTERSECT
SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ010';

-- Úkol 5: Vypište kód a název odvětví, ID záznamu a hodnotu záznamu průměrných mezd a počtu zaměstnanců. Vyberte pouze takové záznamy, které se shodují v uvedené hodnotě a spadají do odvětví s označením A nebo B.

SELECT 
	cpib.*,
	cp.id ,
	cp.value 
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code
WHERE value IN (
	SELECT value 
	FROM czechia_payroll cp2 
	WHERE industry_branch_code = 'A'
	INTERSECT 
	SELECT value 
	FROM czechia_payroll cp3 
	WHERE industry_branch_code = 'B'
);
	
CREATE INDEX i_czechia_payroll_value ON czechia_payroll(value);
DROP NDEX i_czechia_payroll_value ON czechia_payroll;


-- Úkol 6: Vyberte z tabulky czechia_price takové záznamy, které jsou v Jihomoravském kraji jiné na sloupcích category_code a value než v Praze.
SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ064'
EXCEPT 
SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ010';

-- Úkol 7: Upravte předchozí dotaz tak, abychom získali záznamy, které jsou v Praze a ne v Jihomoravském kraji. Dále udělejte průnik těchto dvou disjunktních podmnožin.

(SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ064'
EXCEPT 
SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ010')
INTERSECT 
(SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ010'
EXCEPT 
SELECT category_code, value
FROM czechia_price cp 
WHERE region_code = 'CZ064');

-- projekt: do repozitáře - založit to ještě předtím, než začnu, a%t ej tam i historie - mám to tvořit postupně, klidně po jednotlivých otázkách, mám tam nahrávat soubory s příponou .sql - aby mi to github obarvil
-- k tomu odevzdar i průvdní listinu - slovní odpovědi na otázky, jestli jsem měla s něčím problémy a popsat strukturu projektu
-- ddl ideálně do konce