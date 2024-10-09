-- PART 1: ORDER BY

-- Úkol 1: Vypište od všech poskytovatelů zdravotních služeb jméno a typ. Záznamy seřaďte podle jména vzestupně.
SELECT *
FROM healthcare_provider AS hp
LIMIT 5;
-- chci se jen kouknout na tabulku, ale mohla bych se podívat i v menu

SELECT
	name,
	provider_type
FROM healthcare_provider 
ORDER BY name;
-- v datech je první záznam špatně, protože má jako první znak mezeru, proto použijeme TRIM, který odmaže mezery kolem textu ale ne uprostřed

SELECT
	name,
	provider_type
FROM healthcare_provider hp
ORDER BY TRIM(name);
-- fce = předem definovaný kód, který dělá nějakou operaci - např TRIM
-- odmaže mezery před a za textem - bere to hodnotu jako celek a odmaže to předtím a za tím ale ne uprostřed
-- červený/modrý= reserved keywords, modrý/žlutý = built-in funkce
-- DISTINCT
-- Úkol 2: Vypište od všech poskytovatelů zdravotních služeb ID, jméno a typ. Záznamy seřaďte primárně podle kódu kraje a sekundárně podle kódu okresu.
SELECT
	provider_id,
	name,
	provider_type
FROM healthcare_provider hp
ORDER BY region_code, district_code;

-- Úkol 3: Seřaďte na výpisu data z tabulky czechia_district sestupně podle kódu okresu.

SELECT *
FROM czechia_district cd
ORDER BY code DESC;

-- Úkol 4: Vypište abacedně pět posledních krajů v ČR.
SELECT *
FROM czechia_region cr
ORDER BY name DESC 
LIMIT 5;

-- Úkol 5: Data z tabulky healthcare_provider vypište seřazena vzestupně dle typu poskytovatele a sestupně dle jména.
SELECT *
FROM healthcare_provider hp
ORDER BY provider_type ASC, TRIM(name) DESC;

-- PART 2: CASE EXPRESSION
-- Úkol 1: Přidejte na výpisu k tabulce healthcare_provider nový sloupec is_from_Prague, který bude obsahovat 1 pro poskytovate z Prahy a 0 pro ty mimo pražské.
SELECT
	name,
	region_code
FROM healthcare_provider hp
WHERE name LIKE '%Praha%'
LIMIT 2;
-- vyhledávání podle obsahu % znamená, že před a za slovem Praha je text

SELECT
	name,
	region_code,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_Prague
FROM healthcare_provider hp;

-- Úkol 2: Upravte dotaz z předchozího příkladu tak, aby obsahoval záznamy, které spadají jenom do Prahy.
SELECT
	name,
	region_code,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_Prague
FROM healthcare_provider hp
WHERE region_code="CZ010";

-- Úkol 3: Sestavte dotaz, který na výstupu ukáže název poskytovatele, město poskytování služeb, zeměpisnou délku a v dynamicky vypočítaném sloupci slovní informaci, jak moc na západě se poskytovatel nachází – určete takto čtyři kategorie rozdělení.
SELECT
	name,
	municipality,
	longitude,
	CASE
		WHEN longitude <14 THEN 'nejmin zapad'
		WHEN longitude <16 THEN 'min zapad'
		WHEN longitude <=18 THEN 'jeste min zapad'
		ELSE 'nejvíce na východě'
	END AS orientace_na_zapad
	FROM healthcare_provider hp;

-- Úkol 4: Vypište název a typ poskytovatele a v novém sloupci odlište, zda jeho typ je Lékárna nebo Výdejna zdravotnických prostředků.

-- PART 3: WHERE
-- Úkol 4: Vypište jméno, město a okres místa poskytování u těch poskytovatelů, kteří jsou z Brna, Prahy nebo Ostravy nebo z okresů Most nebo Děčín.
SELECT
	name,
	municipality,
	district_code 
FROM healthcare_provider hp
WHERE
	municipality IN ('Brno', 'Praha', 'Ostrava') OR 
    district_code IN ('CZ0425', 'CZ0421');
   -- district_code IN(
   -- SELECT code
   -- FROM czechia_district
   -- WHERE name IN ('Most, 'Děčín')

-- PART 4: POHELDY (VIEW)
-- Úkol 1: Vytvořte pohled (VIEW) s ID, jménem, městem a okresem místa poskytování u těch poskytovatelů, kteří jsou z Brna, Prahy nebo Ostravy. Pohled pojmenujte v_healthcare_provider_subset.

CREATE OR REPLACE VIEW v_healthcare_provider_subset AS
	SELECT
		provider_id,
		name,
		municipality,
		district_code
	FROM healthcare_provider hp
	WHERE municipality IN ('Brno', 'Praha', 'Ostrava');
	
SELECT *
FROM v_healthcare_provider_subset;

-- pozor! Hvězdičku nikdy kor ve VIEW. VIEW je dynamické může se měnit i počet sloupců a když se stím pak někde dále pracuje tak pak ty procedury můžou padat :)

-- 'v_' nebo 'view_' v názvu značí, že to je view, potřeba to takto označit
-- OR REPLACE pozor na to - mám na to oprávnění?
