-- KAPITOLA 1 – SELECT

-- Úkol 1: Vypište všechna data z tabulky healthcare_provider.
SELECT *
FROM healthcare_provider;
-- přeložili bychom to jako: vyber vše z tabulky helthcare_provider

-- Úkol 2: Vypište pouze sloupce se jménem a typem poskytovatele ze stejné tabulky jako v předchozím příkladu.
SELECT
	name,
	provider_type
FROM healthcare_provider;

-- Úkol 3: Předchozí dotaz upravte tak, že vypíše pouze prvních 20 záznamů v tabulce.
SELECT
	name,
	provider_type
FROM healthcare_provider
LIMIT 20 OFFSET 10;
-- offset - kolik těch záznamů mám / Limit - jaký je limit

-- řádkový komentář

/*
 * blokový komentář
 */

-- Úkol 4: Vypište z tabulky healthcare_provider záznamy seřazené podle kódu kraje vzestupně.
SELECT *
FROM healthcare_provider
ORDER BY region_code ASC;

-- ASC ascending je nastavený automaticky, takže to tam nepsat
-- DESC descending - 'ORDER BY region_code DESC'

-- mariadb.com - tam najdu příkazy, to co je v hranatých závorkách je nepovinné

-- Úkol 5: Vypište ze stejné tabulky jako v předchozím příkladě sloupce se jménem poskytovatele, kódem kraje a kódem okresu. 
-- Data seřaďte podle kódu okresu sestupně. Nakonec vyberte pouze prvních 500 záznamů.
SELECT
	name,
	region_code,
	district_code
FROM healthcare_provider
ORDER BY district_code DESC
LIMIT 500;

-- KAPITOLA 2: WHERE
-- Úkol 1: Vyberte z tabulky healthcare_provider všechny záznamy poskytovatelů zdravotních služeb, kteří poskytují služby v Praze (kraj Praha).
-- nejdřív se podívám jaký kód má praha - zobrazím si všechny kraje s kódy
SELECT *
FROM czechia_region;

SELECT *
FROM healthcare_provider hp
WHERE region_code ='CZ010';

-- když chci konstantu textovovu, potřebuju to dát do uvozovek - jednoduchých! - jinak to vybere sloupce
-- (dvojté uvozovky jsou názvy sloupce v jiných sql, takže je lepší používat ty jednoduché)
-- hp - automaticky doplnuje table alias - bude to pak jednodušší
-- 'FROM healthcare_provider AS hp' - AS aliasing - dá se to vynechat - co můžeme vynechat, vynechý

-- Úkol 2: Vyberte ze stejné tabulky název a kotaktní informace poskytovatelů, kteří nemají místo poskytování v Praze (kraj Praha).
SELECT
	name,
	phone,
	fax,
	email,
	website
FROM healthcare_provider
WHERE region_code != 'CZ010';

-- != nebo <> nerovná se

-- Úkol 3: Vypište názvy poskytovatelů, kódy krajů místa poskytování a místa sídla u takových poskytovatelů, u kterých se tyto hodnoty rovnají.
SELECT
	name,
	region_code,
	residence_region_code
FROM healthcare_provider
WHERE region_code = residence_region_code;

-- Úkol 4: Vypište název a telefon takových poskytovatelů, kteří svůj telefon vyplnili do registru.
SELECT
	name,
	phone
FROM healthcare_provider
WHERE phone IS NOT NULL;

-- Úkol 5: Vypište název poskytovatele a kód okresu u poskytovatelů, kteří mají místo poskytování služeb v okresech Benešov a Beroun.
-- Záznamy seřaďte vzestupně podle kódu okresu.
-- nejdříve zjistíme district code u daných obcí
SELECT *
FROM czechia_district cd;

SELECT
	name,
	district_code
FROM healthcare_provider
WHERE district_code = 'CZ0201' OR district_code = 'CZ0202'
ORDER BY district_code;

-- KAPITOLA 3: ÚPRAVA TABULEK
-- přesouváme se do kategorie destruktivních dotazů - můžeme přemazávat data - nespouštět v primárních tabulkách!

-- Úkol 1: Vytvořte tabulku t_{jméno}_{příjmení}_providers_south_moravia z tabulky healthcare_provider vyberte pouze Jihomoravský kraj.

CREATE OR REPLACE TABLE t_engeto_zuzana_providers_south_moravia AS
SELECT *
FROM healthcare_provider hp 
WHERE region_code = 'CZ064';

-- ještě se dá použít toto CREATE TABLE IF NOT EXISTS
-- AS tam být nemusí, ale některé rozhraní to můžou chtít

SELECT *
FROM t_engeto_zuzana_providers_south_moravia;

-- Úkol 2: Vytvořte tabulku t_{jméno}_{příjmení}_resume, kde budou sloupce date_start, date_end, job, education. Sloupcům definujte vhodné datové typy.

CREATE TABLE t_engeto_zuzanar_resume (
	date_start date,
	date_end date,
	job varchar(255),
	education varchar(255);
);
-- přejmenovat tabulku
ALTER TABLE t_engeto_zuzanar_resume RENAME TO t_zuzana_roztocilova_resume;

SELECT *
FROM t_zuzana_roztocilova_resume;
	
-- datový typ mi říká jaký obor hodnot tam můžu vložit
-- zatím je ta tab prázdná

-- KAPITOLA 4 Vkládání dat do tabulky

-- Úkol 1: Vložte do tabulky popis_tabulek pod svým jménem popis tabulky.


-- Úkol 2: Do tabulky t_{jméno}_{příjmení}_resume, kterou jste vytvořili v minulé části, vložte záznam se svým současným zaměstnáním nebo studiem.
-- Nápověda: Pole date_end bude v tomto případě prázdná hodnota. Tu zaznamenáme jako null.
INSERT INTO t_zuzana_roztocilova_resume
VALUES ('2020-02-01', NULL, 'analytik', 'FSV UK');

-- Úkol 3: Do tabulky t_{jméno}_{příjmení}_resume vložte další záznamy. Zkuste použít více způsobů vkládání.
-- Poznámka: Pokud nechcete uvádět skutečné informace, klidně si vytvořte své alter ego :)
INSERT INTO t_zuzana_roztocilova_resume
VALUES ('2020-02-01', NULL, 'učitel', 'ISS MUNI');
INSERT INTO t_zuzana_roztocilova_resume
VALUES (NULL, NULL, 'dělník', 'FSV UK');
-- potřebuju updatovat údaj v tabulce
UPDATE t_zuzana_roztocilova_resume
SET job = 'Developer'
WHERE job = 'Učitel';

-- v tabulce chybí ID, což mi brání udělat některé příkazy

-- smazání tabulky
DELETE FROM t_zuzana_roztocilova_resume
-- takhle bych ji smazala celou, sql mě upozorní
-- smazat jeden záznam z tabulky - žádné upozornění, takže to rovnou maže
DELETE FROM t_zuzana_roztocilova_resume
WHERE date_start IS NULL;
-- přidání sloupce
ALTER TABLE t_zuzana_roztocilova_resume
	ADD COLUMN institution varchar(255),
	ADD COLUMN role varchar (255);

INSERT INTO t_zuzana_roztocilova_resume
VALUES ('2020-02-01', NULL, 'učitel', 'ISS MUNI', 'FSV', 'ucitel');

-- odtranění sloupce - pozor destrukční dotaz
ALTER TABLE t_zuzana_roztocilova_resume
	DROP COLUMN role;
-- ostranění tabulky - pozor destrukční dotaz
DROP TABLE t_zuzana_roztocilova_resume;
DROP TABLE t_engeto_zuzana_providers_south_moravia;

CREATE TABLE t_test_zr(
	id int UNIQUE
	);
-- unique - integritní omezení - každé číslo jen jednou, ty omezení můžou být různá

INSERT INTO t_test_zr VALUES (1);
INSERT INTO t_test_zr VALUES (2);
INSERT INTO t_test_zr VALUES (3);
INSERT INTO t_test_zr VALUES (4);
INSERT INTO t_test_zr VALUES (5);

SELECT *
FROM t_test_zr;

-- pozor destrukční dotaz
DROP TABLE t_test_zr;
