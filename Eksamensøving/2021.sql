INSERT INTO table_now() VALUES()

UPDATE table_name SET(column1 = , column2=) WHERE condition;

DELETE FROM table_name WHERE condition;

DROP TABLE tablename;

ALTER TABLE table_name ADD columnName datatype;

CREATE TABLE tablename(column1 datatype constraint,)

SELECT FROM WHERE GROUP BY HAVING



Flervalg: 

--1 Select oppdaget = null; --> 2 Egentlig 0 Hmmmm
--2 Måne oppdaget i 2019 og planet oppdaget i 2017 --> 2 Its two as we actually get a cartesian product from this
--3 Oppdaget måne og planet >= 2017 --> 5 Yes it is 5 originally but UNION removes duplicates when we only take oppdaget we therefore get 3
--4 Sid with count over 1 --> 2
--5 Satelitt with natural join --> 2 --> Egentlig 0 fordi krsæjer på navn
--6 Distinct og like en spesifik --> 1

--2.2 Store stjerner 
SELECT navn, masse, lysstyrke 
FROM stjerne 
WHERE masse > 200 OR lysstyrke < 10

--2.3 Planeter i solsystem 
SELECT navn, masse
FROM planet
WHERE sid = (SELECT sid FROM planet WHERE navn = 'Tellus')
ORDER BY masse ASC 

--2.4 
UPDATE stjerne SET masse=masse*0.45
WHERE oppdaget < 1990 AND oid = (SELECT oid FROM obersvator AS obs WHERE obs.navn = 'BESS');

--2.5
CREATE VIEW universitet(antall,masse) AS
WITH 
    alle_objekter AS (
        SELECT masse FROM stjerne
        UNION ALL
        SELECT masse FROM planet
        UNION ALL 
        SELECT masse FROM måne
    )
SELECT count(*) AS antall, sum(masse) AS masse
FROM alle_objekter

--2.6 Store solsystemer 

FROM stjerne AS s FULL JOIN planet AS p ON(p.sid = s.sid)
FULL JOIN måne AS m ON(m.pid = p.pid)
GROUP BY stjerne
HAVING count(UNIQUE p.navn)>10 OR sum(m.masse)+sum(p.masse)+s.masse > 400 -- I think this solution has some duplicate issues

-- Actual solution
WITH solsystemer AS (
    SELECT sid,navn AS stjerne, masse
    FROM stjerne 
    UNION ALL
    SELECT s.sid, s.navn AS stjerne, p.masse 
    FROM stjerne AS s
        JOIN planet AS p USING (sid)
    UNION ALL 
    SELECT s.sid, s.navn AS stjerne, p.masse
    FROM stjere AS select
        JOIN planet AS p USING(sid)
        JOIN måne AS m USING(pid)
)
SELECT stjerne 
FROM solsystemer
GROUP BY sid, stjerne
HAVING sum(masse) >400
UNION ALL
SELECT s.navn AS stjerne
FROM stjerne AS select
    JOIN planet AS p USING (sid)
GROUP BY s.sid, s.navn
HAVING count(*) > 10


-- Relasjonsalgebra

SELECT navn
FROM observator JOIN (SELECT oid AS soid FROM stjerne WHERE lysstyrke > 50) AS t ON oid = soid;

