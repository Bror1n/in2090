-- Task 1 Find names and roles of all actors in 'Star Wars'
SELECT p.firstname AS first_name,p.lastname AS last_name , fc.filmcharacter AS roll
FROM film AS f JOIN filmparticipation AS fp ON(f.filmid = fp.filmid) 
JOIN filmcharacter AS fc ON(fc.partid = fp.partid) 
JOIN person AS p ON(fp.personid = p.personid)
WHERE f.title LIKE '%Star Wars%';

/*
Beatrice Arthur Ackmena
Marty Balin Mermeia Holographic Vow
1784 rows
*/

-- Task 2 Find count of films in every country order desc
SELECT country, count(filmid)
FROM filmcountry
GROUP BY country
ORDER BY count(filmid) DESC;

-- Worked 190 rows
-- us 206556

-- Task 3 Find average runtime of film per country (Where country is not null),
-- We only want countries with atleast 200 runtimes
SELECT r.country ,AVG(CAST(r.time AS integer)) AS avg_runtime
FROM runningtime AS referanse
WHERE r.country IS NOT NULL 
    AND time ~'^\d+$'
GROUP BY r.country
HAVING count(r.time) > 200
ORDER BY avgtime DESC;


--Task 4 10 movies with most genres (if more than one with same genres order by alphabetical order)
SELECT f.title, filmcount
FROM (
    SELECT g.filmid AS filmid, count(g.filmid) AS genrecount
    FROM filmgenre AS g
    GROUP BY g.filmid
) AS sub
INNER JOIN filmid AS f ON(f.filmid = sub.filmid)
ORDER BY sub.genrecount
LIMIT 10;


-- Task 5 total movies in a country, average rating for movies, and most common genre 
SELECT sq1.country, sq1.avg_score, sq1.filmcount, sq2.mostPopGenre
FROM
(SELECT fc.country, avg(fr.rank) AS avg_score, COUNT(fc.filmid) AS filmcount
FROM filmcountry AS fc JOIN filmrating AS fr ON(fc.filmid = fr.filmid)
GROUP BY fc.country
) AS sq1 
JOIN
(SELECT fc.country, max(fg.genre) as mostPopGenre
FROM filmcountry AS fc JOIN filmgenre AS fg ON(fc.filmid = fg.filmid)
GROUP BY fc.country) AS sq2
ON (sq1.country = sq2.country)
ORDER BY sq1.avg_score ASC;


-- This finally worked i hate my life
-- Haha pakistan makes the worst movies and india makes the best?

-- Task 6 Find pairs of countries that have worked the most with eachother

SELECT *, count(*) as movies
FROM filmcountry AS fc1 JOIN filmcountry AS fc2 ON (fc1.filmid = fc2.filmid)
WHERE fc1.country < fc2.country
GROUP BY fc1.country, fc2.country
HAVING count(*) > 150


--Task 7

SELECT Distinct f.title, f.prodyear
FROM filmcountry AS fc RIGHT JOIN film AS f ON(c.filmid = f.filmid)
JOIN filmgenre AS fg ON(fg.filmid = f.filmid)
WHERE (fg.genre = 'Horror' OR fc.country='Romania') AND (f.title LIKE '%Dark%' OR f.title LIKE '%Night%');


--457 rows nice

--Task 8 Lunch 
-- Find title, and amount of participants of a movie made after 2010 and 2 or less paricipants

SELECT f.title, count(fp.filmid)
FROM filmparticipation as fp RIGHT OUTER JOIN film AS f ON(f.filmid = fp.filmid)
WHERE f.prodyear > 2009
GROUP By f.title
HAVING count(fp.filmid) < 3;

-- 28 ROWS


--Task 9
SELECT UNIQUE f.name
FROM filmgenre AS fg1 JOIN filmgenre AS f2 ON(fg1.filmid = fg2.filmid)
JOIN film AS f ON (fg1.filmid = f.filmid)
Where fg1.genre != 'Sci-FI' and fg.2genre != 'Horror'

-- 6727 rows

--Task 10
WITH interestingMovies AS ( 
    SELECT f.title AS title, f.filmid AS filmid
    FROM filmrating AS fr JOIN film AS f ON(f.filmid = fr.filmid) 
    JOIN filmitem AS fi ON(f.filmid = fi.filmid)
    WHERE fr.votes > 1000 AND fr.rank >= 8 AND fi.filmtype = 'C'
    ORDER BY fr.rank DESC, fr.votes DESC
),
top10 AS (
    SELECT im.title
    FROM interestingMovies AS im
    LIMIT 10
),
harrisonMovies AS (
    SELECT im.title 
    FROM interestingMovies AS im JOIN filmparticipation AS fp ON(fp.filmid = im.filmid)
    JOIN person AS p ON(p.personid = fp.personid)
    WHERE p.firstname LIKE '%Harrison%' AND p.lastname LIKE '%Ford%'
),
comedyRomance AS (
    SELECT im.title
    FROM interestingMovies AS im JOIN filmgenre AS fg ON (im.filmid = fg.filmid) 
    WHERE fg.genre = 'Comedy' OR fg.genre = 'Romance'
)
SELECT *
FROM (
    SELECT top10.title
    FROM top10
    UNION
    SELECT harrisonMovies.title
    FROM harrisonMovies
    UNION
    SELECT comedyRomance.title
    FROM comedyRomance
) AS sub;

--170 Rows yippie

