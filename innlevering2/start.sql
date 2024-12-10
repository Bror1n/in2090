--CREATE SCHEMA hf;

CREATE TABLE stjerne(
    navn text PRIMARY KEY,
    avstand int,
    masse int
);

CREATE TABLE planet(
    navn text PRIMARY KEY,
    masse int,
    oppdaget year,
    stjerne text REFERENCES hf.stjerne(navn)
);

CREATE TABLE materie(
    planet text,
    molekyl text,
    PRIMARY KEY (planet, molekyl),
    FOREIGN KEY (planet) REFERENCES hf.planet(navn)
);

-- Task 2
--a) Find the name of all planets that orbits the star Proxima
SELECT navn FROM planet
WHERE (stjerne = 'Proxima Centauri');

--Output
--Proxima Centauri b 
--Proxima Centauri d

--b) What years (without duplicates) was there discovered planets orbiting around 'TRAPPIST-1' and 'Kepler-154'
SELECT oppdaget
FROM planet AS p INNER JOIN stjerne AS s
    ON (p.stjerne = s.navn)
WHERE (s.navn = 'TRAPPIST-1' OR s.navn = 'Kepler-154')
GROUP BY oppdaget;

-- Output 2014, 2016, 2017 2019

--c) Number of planets that do not have a mass (has a null value)
SELECT count(*)
FROM planet
WHERE masse IS NULL;

--d) Name and mass of all planets discovered in 2020, with a mass higher than the average mass of all planets
SELECT navn, masse
FROM planet 
WHERE oppdaget = 2020 AND masse > (SELECT avg(masse) FROM planet);

--output
--navn, masse
-- GPX-1 b , 19.7
-- WISEA JO83... , 8.5
--... 19 rows

--e) Number of years between the first and last found planete in planet table
SELECT max(oppdaget) - min(oppdaget)
FROM planet;

--e 34

--TASK 3
--a) Find a planet with water and a mass between 3 and 10 
SELECT p.navn
FROM planet AS p INNER JOIN materie AS m 
    ON (p.navn = m.planet)
WHERE p.masse > 3 AND p.masse < 10 AND m.molekyl='H2O';

--Output
--Kepler-167 e
-- HR 8799 c
--6 rows

--b) Second model where (Planet needs to be a distance less than 12 times its mass), (Needs a molecule that contains H)
SELECT p.navn
FROM planet AS p INNER JOIN stjerne AS s 
    ON (p.stjerne = s.navn)
INNER JOIN materie AS m ON (m.planet = p.navn)
WHERE s.avstand < s.masse * 12 AND m.molekyl LIKE '%H%';

--Output 
--GJ 570 D
--GJ 832 c
--8 rows

--c) Third model (2 planets with mass over 10) (with distance from starsystem < 50)
SELECT p.planet
FROM (SELECT stjerne, COUNT(stjerne) AS planet_count
    FROM planet 
    WHERE masse > 10
    GROUP BY stjerne
    HAVING COUNT(navn) > 1
) AS sc 
INNER JOIN stjerne AS s 
    ON (sc.stjerne = s.stjerne)
INNER JOIN planet AS p 
    (sc.stjerne = p.stjerne)
WHERE s.avstand < 50;

/* 
Output 
HIP 75458 c
HD 82943 d
HD 83943 b
5 rows
*/

-- TASK 4
-- Find out when planets thar orbits star with distance over 8000 was discovered

--my code--
SELECT p.oppdaget, s.navn
FROM planet AS p INNER JOIN stjerne AS s
    ON (p.stjerne = s.navn)
WHERE s.avstand > 8000;

--NILS code--
SELECT oppdaget
FROM planet NATURAL JOIN stjerne
WHERE avstand > 8000;
/* 
The main problem with nils code is that a natural join will not work as expected is that natural join 
the tables on the same named columns, however we want to join them on the name if star and their name
not on the name of planet joined on name of star, as these will never match
*/

--TASK 5--
--Insert planet and sun into system--

--a insert the sun
INSERT INTO stjerne
VALUES ('Sola',0,1);

--b insert the earth
INSERT INTO planet
VALUES ('Jorda',0.003146,NULL,'Sola');


--TASK 6
-- Make TABLE called observasjon(observasjons_id(heltall), tidspunkt(timestamp), planet(referanse), kommentar(text))

CREATE TABLE observasjon(
    observasjons_id SERIAL PRIMARY KEY,
    tidspunkt timestamp, 
    planet text REFERENCES planet(navn),
    kommentar text
);

