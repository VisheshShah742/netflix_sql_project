create database netflix_db;
use netflix_db;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director	VARCHAR(208),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year	INT,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description	VARCHAR(250)
);
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
	COUNT(*) as total_content
FROM netflix;

SELECT
	DISTINCT type
FROM netflix;

select * FROM netflix;

-- 15 Business Problems

-- 1. Count the Number of Movies vs TV Shows

SELECT 
    type,
    COUNT(*) as total_content
FROM netflix
GROUP BY type;

-- 2. Find the Most Common Rating for Movies and TV Shows

SELECT
	type,
    rating
FROM
(
SELECT
	type,
    rating,
	COUNT(*),
    RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1, 2
) as t1
WHERE
	ranking = 1;
    
-- 3. List All Movies Released in a Specific Year (e.g., 2020)
    
-- filter 2020
-- movies

SELECT * FROM netflix
WHERE
	type = 'Movie'
    AND
    release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT country, COUNT(show_id) AS total_content
FROM netflix
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

-- 5. Identify the Longest Movie

SELECT * FROM netflix
WHERE 
	type = 'Movie'
    AND
    duration = (SELECT MAX(duration) FROM netflix);
    
-- 6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List All TV Shows with More Than 5 Seasons

SELECT title, duration
FROM netflix
WHERE type = 'TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 9.Find each year and the average numbers of content release in India on netflix.

SELECT 
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year,
    COUNT(*) AS total_content,
    AVG(COUNT(*)) OVER () AS avg_content_per_year
FROM netflix
WHERE country LIKE '%India%'
GROUP BY year
ORDER BY year;

-- 10. List All Movies that are Documentaries

SELECT title, listed_in
FROM netflix
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';

-- 11. Find All Content Without a Director

SELECT title, type
FROM netflix
WHERE director IS NULL
   OR TRIM(director) = '';
   
-- 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
AND casts LIKE '%Salman Khan%'
AND STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 10 YEAR;

-- 13. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

 SELECT 
    title,
    CASE 
        WHEN LOWER(description) LIKE '%kill%' 
          OR LOWER(description) LIKE '%violence%' 
        THEN 'Violent Content'
        ELSE 'Non-Violent Content'
    END AS category
FROM netflix;