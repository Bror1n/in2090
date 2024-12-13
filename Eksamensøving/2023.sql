-- Skriv en spørring sm finner alle vedlikeholdsdatoer for sensorer i Oslo sortert kronologisk
SELECT vedlikeholdt
FROM sensor JOIN område ON(oid)
WHERE navn = 'Oslo'
ORDER BY vedlikeholdt ASC;

-- Gjenomsnitttemperatur i Bærum
SELECT avg(temp)
FROM område JOIN sensor ON(oid) 
JOIN måling ON(sid)
WHERE navn = 'Bærum' AND (nedbør > 0 OR vind > 5)
GROUP BY navn;

--Få sensorer
SELECT navn
FROM område AS o JOIN (SELECT oid, count(oid) AS oid_count FROM sensor GROUP BY oid) AS s ON (s.oid=o.oid)
ORDER BY (oid_count/areal) ASC
LIMIT 3;

--Analyse
CREATE VIEW AS Analyse_vind 
SELECT sid, tidspunkt, vind
FROM måling
WHERE vind IS NOT NULL
UNION alle
SELECT m.sid, m.tidsspunkt, avg(o,vind)
FROM måling AS m JOIN måling AS o using (sid)
WHERE m.tidspunkt::date = o.tidspunkt o.tidspunkt::date AND
    m.vind IS NULL AND
    o.vind IS NOT NULL
GROUP BY m.sid, m.tidsspunkt


--Nedbørsmengder
--Navn med høyeste gjennomsnittlig nedsbørmengde per dag i 2023. Ta kun med område og dager som har mere enn 10 målinger
-- Anta at alle målingene på nedbør har verdi
-- Anta at summen av alle nedbør verdier for en dag er den 


WITH målingPerDag AS (
    SELECT o.navn AS navn, avg(nedbør) AS nedbør_avg
    FROM sensor AS s JOIN område AS o ON(oid)
    JOIN måling AS m ON(sid)
    GROUP BY o.navn, m.tidspunkt::date
    HAVING count(måling) > 10
)
SELECT navn
FROM målingPerDag 
GROUP BY navn
ORDER BY sum(nedbør_avg) DESC;

--Programmering SQL
