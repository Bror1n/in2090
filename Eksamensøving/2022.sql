/*
Sql flervalg
1. Navn like %i --> 2
2. Rating <= 2200 --> 2
3. Mina vinner som sort --> 1
4. Union ALL --> 4
5. Join on tid where hvit er --> 4
6. Select distinct count --> 2 
*/

--2.2 Lynsjakk i november 
SELECT Navn
FROM turnering
WHERE spilltype = 'lynsjakk' 
    AND startdato >= 2022-11-01 
    AND startdato <= 2022-11-30;

SELECT avg(tid_brukt)
FROM tunering JOIN parti ON(tid)
JOIN trekk ON(pid)
WHERE navn = 'Oslo Open'
-- GROUP BY pid


--2.4
DELETE 
FROM parti
WHERE resultat = 'remis' AND
    tid = (
        SELECT tid
        FROM turnering
        WHERE navn = 'Sjakkelakke'
    );

CREATE VIEW resultat(pid,sid,utfall) AS
SELECT pid, hvit, 'vant'
FROM parti
WHERE vinner ='hvit'
UNION
SELECT pid, sort, 'vant'
FROM parti
WHERE vinner = 'sort'
UNION
SELECT pid, hvit, 'tapte'
FROM parti 
WHERE vinner = 'sort'
UNION
SELECT pid, sort, 'tapte'
FROM parti
WHERE vinner='hvit'
UNION
SELECT pid, hvit, 'remis'
FROM parti 
WHERE vinner = 'remis'
UNION
SELECT pid, sort, 'remis'
FROM parti
WHERE vinner = 'remis';

--2.6 Winners
WITH 
    poeng AS(
        SELECT tid,sid, 1 AS poeng
        FROM resultat JOIN parti USING (pid)
        WHERE utfall ='vant'
        UNION 
        SELECT tid, sid, 0.5 AS poeng
        FROM resultat JOIN parti USING (pid)
        WHERE utfall ='tapte'
    ),
    sum_poeng AS(
        select sid,tid, sum(poeng)
        FROM poeng
        GROUP BY tid,sid
    )
SELECT t.navn, s.navn AS vinner
FROM turnering AS t, spiller AS s
WHERE s.sid = (
    SELECT p.sid
    FROM sum_poeng AS parti
    WHERE p.tid = t.tid
    ORDER BY total DESC
    LIMIT ;
);

