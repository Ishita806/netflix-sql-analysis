-- ============================================================
--        NETFLIX DATA ANALYSIS PROJECT
--        Tool     : MySQL

-- ============================================================
-- STEP 1 : DATABASE SETUP
-- ============================================================

CREATE DATABASE netflix_project;

USE netflix_project;


-- ============================================================
-- STEP 2 : CREATE TABLE
-- ============================================================

CREATE TABLE netflix (
    show_id      VARCHAR(10),
    type         VARCHAR(20),
    title        VARCHAR(200),
    director     VARCHAR(250),
    casts        TEXT,
    country      VARCHAR(150),
    date_added   VARCHAR(50),
    release_year INT,
    rating       VARCHAR(20),
    duration     VARCHAR(30),
    listed_in    VARCHAR(200),
    description  TEXT
);


-- ============================================================
-- STEP 3 : IMPORT DATA
-- ============================================================

-- Import the Netflix CSV file using MySQL Workbench
-- Table Data Import Wizard


-- ============================================================
-- STEP 4 : BASIC EXPLORATION
-- ============================================================

-- View all records
SELECT * FROM netflix;

-- View selected columns
SELECT title, country, release_year FROM netflix;

-- Filter only Movies
SELECT * FROM netflix WHERE type = 'Movie';

-- Filter only TV Shows
SELECT title, type FROM netflix WHERE type = 'TV Show';

-- Unique countries in the dataset
SELECT DISTINCT country FROM netflix;

-- Unique ratings in the dataset
SELECT DISTINCT rating FROM netflix;

-- Sort by release year (Newest first)
SELECT title, release_year FROM netflix
ORDER BY release_year DESC;

-- Sort by release year (Oldest first)
SELECT title, release_year FROM netflix
ORDER BY release_year ASC;

-- View first 5 records
SELECT * FROM netflix
LIMIT 5;

-- Top 3 most recently released titles
SELECT title, release_year FROM netflix
ORDER BY release_year DESC
LIMIT 3;

-- View title and country for first 10 records
SELECT title, country FROM netflix
LIMIT 10;

-- Top 5 most recently released titles
SELECT title, release_year FROM netflix
ORDER BY release_year DESC
LIMIT 5;


-- ============================================================
-- STEP 5 : DATA CLEANING
-- ============================================================

-- Q1. How many records have missing country values?
SELECT COUNT(*) AS missing_country
FROM netflix
WHERE country IS NULL OR country = '';

-- Q2. Replace missing country values with 'Unknown'
SET SQL_SAFE_UPDATES = 0;

UPDATE netflix
SET country = 'Unknown'
WHERE country IS NULL OR country = '';

SET SQL_SAFE_UPDATES = 1;

-- Verify: Check if any missing values remain
SELECT COUNT(*) FROM netflix
WHERE country IS NULL OR country = '';

/*
   Insight: Missing country values were standardised as 'Unknown'
   to improve dataset readability and consistency.
*/


-- ============================================================
-- STEP 6 : DATA ANALYSIS — BUSINESS QUESTIONS
-- ============================================================

-- Q3. How many Movies and TV Shows are available on Netflix?
SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type;

/*
   Insight: Movies contribute slightly more content than TV Shows on Netflix.
*/

-- ----------------------------------------------------------

-- Q4. Which are the top 5 countries with the highest Netflix content?
SELECT country, COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL AND country != ''
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

/*
   Insight: United States has the highest Netflix content in the dataset,
   followed by Japan and India.
*/

-- ----------------------------------------------------------

-- Q5. What are the most common ratings on Netflix?
SELECT rating, COUNT(*) AS total_rating
FROM netflix
GROUP BY rating
ORDER BY total_rating DESC;

/*
   Insight: TV-MA is the most common rating, showing that Netflix contains
   a large amount of mature audience content.
*/

-- ----------------------------------------------------------

-- Q6. Find all Movies released after 2020
SELECT title, release_year
FROM netflix
WHERE type = 'Movie' AND release_year > 2020;

/*
   Insight: Netflix contains several recently released movies, showing
   continuous addition of modern content to the platform.
*/

-- ----------------------------------------------------------

-- Q7. Find content where director information is missing
SELECT title, director
FROM netflix
WHERE director IS NULL OR director = '';

/*
   Insight: Several records contain missing director information,
   indicating inconsistent data quality.
*/

-- ----------------------------------------------------------

-- Q8. Find the longest movies on Netflix
SELECT title, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(REPLACE(duration, 'min', '') AS UNSIGNED) DESC
LIMIT 5;

/*
   Insight: 'Jeans' is the longest movie in the dataset with a duration of 166 minutes.
*/

-- ----------------------------------------------------------

-- Q9. Count content added each year

-- Date format conversion check
SELECT date_added, STR_TO_DATE(date_added, '%M %d, %Y') AS formatted_date
FROM netflix;

-- Content count per year
SELECT
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS added_year,
    COUNT(*) AS total_content
FROM netflix
WHERE date_added IS NOT NULL AND date_added != ''
GROUP BY added_year
ORDER BY added_year;

/*
   Insight: The available dataset primarily contains content added in 2021.
*/

-- ----------------------------------------------------------

-- Q10. Find all content added in 2021
SELECT title, type, date_added
FROM netflix
WHERE YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) = 2021;

/*
   Insight: The dataset mainly contains Netflix content added during September 2021.
*/

-- ----------------------------------------------------------

-- Q11. Find all TV Shows with more than 1 season
SELECT
    title,
    CAST(REPLACE(REPLACE(duration, ' Seasons', ''), ' Season', '') AS UNSIGNED) AS season_count
FROM netflix
WHERE type = 'TV Show'
  AND CAST(REPLACE(REPLACE(duration, ' Seasons', ''), ' Season', '') AS UNSIGNED) > 1
ORDER BY season_count DESC;

/*
   Insight: Several Netflix TV Shows contain multiple seasons,
   with some titles extending up to 9 seasons.
*/

-- ----------------------------------------------------------

-- Q12. Find the most common rating on Netflix
SELECT rating, COUNT(*) AS total_rating
FROM netflix
GROUP BY rating
ORDER BY total_rating DESC
LIMIT 1;

/*
   Insight: TV-MA is the most common content rating — a large portion
   of Netflix content targets mature audiences.
*/

-- ----------------------------------------------------------

-- Q13. Find directors with more than 1 title in the dataset
SELECT director, COUNT(title) AS title_count
FROM netflix
WHERE director IS NOT NULL AND director != ''
GROUP BY director
HAVING COUNT(title) > 1;

/*
   Insight: Toshiya Shinohara has the highest number of titles in the dataset,
   followed by Masahiko Murata.
*/

-- ----------------------------------------------------------

-- Q14. Find content released after 2020 with rating TV-MA
SELECT title, rating, release_year
FROM netflix
WHERE release_year > 2020
  AND rating = 'TV-MA';

/*
   Insight: Several titles released in 2021 were rated TV-MA, showing a strong
   presence of mature-themed content in the dataset.
*/

-- ----------------------------------------------------------

-- Q15. Find content from India
SELECT country, COUNT(*) AS total_content
FROM netflix
WHERE country LIKE '%India%'
GROUP BY country;

/*
   Insight: India appears both as a standalone country and as part of
   multi-country collaborations in the dataset.
*/

-- ----------------------------------------------------------

-- Q16. Find all Movies longer than 120 minutes
SELECT
    title,
    CAST(REPLACE(duration, 'min', '') AS UNSIGNED) AS total_duration
FROM netflix
WHERE type = 'Movie'
  AND CAST(REPLACE(duration, 'min', '') AS UNSIGNED) > 120;

/*
   Insight: Several movies in the dataset exceed 120 minutes in duration.
*/

-- ----------------------------------------------------------

-- Q17. Find the number of Movies and TV Shows released each year
SELECT type, release_year, COUNT(*) AS total
FROM netflix
GROUP BY type, release_year
ORDER BY release_year;

/*
   Insight: 2021 contains the highest number of both Movies and TV Shows in the dataset.
*/

-- ----------------------------------------------------------

-- Q18. Categorize Movies as Short, Medium, or Long
SELECT
    title,
    CAST(REPLACE(duration, 'min', '') AS UNSIGNED) AS total_duration,
    CASE
        WHEN CAST(REPLACE(duration, 'min', '') AS UNSIGNED) < 90          THEN 'Short'
        WHEN CAST(REPLACE(duration, 'min', '') AS UNSIGNED) BETWEEN 90 AND 120 THEN 'Medium'
        ELSE 'Long'
    END AS duration_category
FROM netflix
WHERE type = 'Movie';

/*
   Insight: Most movies in the dataset fall under the Medium duration category (90–120 min).
   Only a few movies exceed 120 min, making long-duration content relatively less common.
*/

-- ----------------------------------------------------------

-- Q19. Find the average movie duration
SELECT AVG(CAST(REPLACE(duration, 'min', '') AS UNSIGNED)) AS avg_movie_duration
FROM netflix
WHERE type = 'Movie';

/*
   Insight: The average movie duration in the dataset is approximately 101 minutes,
   indicating that most Netflix movies are feature-length films.
*/

-- ----------------------------------------------------------

-- Q20. Find movies longer than the average movie duration
SELECT title, duration
FROM netflix
WHERE type = 'Movie'
  AND CAST(REPLACE(duration, 'min', '') AS UNSIGNED) > (
      SELECT AVG(CAST(REPLACE(duration, 'min', '') AS UNSIGNED))
      FROM netflix
      WHERE type = 'Movie'
  );

/*
   Insight: Several movies in the dataset have durations greater than the average
   runtime of approximately 101 minutes.
*/

-- ----------------------------------------------------------

-- Q21. Find the top 3 longest movies
SELECT title, CAST(REPLACE(duration, 'min', '') AS UNSIGNED) AS duration_mins
FROM netflix
WHERE type = 'Movie'
ORDER BY duration_mins DESC
LIMIT 3;

/*
   Insight: 'Jeans' is the longest movie in the dataset with a duration of 166 minutes.
*/

-- ----------------------------------------------------------

-- Q22. Find the top 3 countries with the highest number of content titles
SELECT country, COUNT(*) AS total_content
FROM netflix
WHERE country != 'Unknown'
GROUP BY country
ORDER BY total_content DESC
LIMIT 3;

/*
   Insight: The United States has the highest number of content titles in the dataset,
   followed by Japan and India.
*/

-- ----------------------------------------------------------

-- Q23. Find content added in the last 7 days of the dataset
SELECT title, type, date_added
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(
    (SELECT MAX(STR_TO_DATE(date_added, '%M %d, %Y')) FROM netflix),
    INTERVAL 7 DAY
);

/*
   Insight: Most of the latest content in the dataset was added between
   September 19 and September 25, 2021.
   Both Movies and TV Shows were consistently added during the final week
   represented in the dataset.
*/

-- ----------------------------------------------------------

-- Q24. Find movies released in the same year (Self Join)
SELECT
    a.title AS movie_1,
    b.title AS movie_2,
    a.release_year
FROM netflix a
JOIN netflix b
    ON a.release_year = b.release_year
WHERE a.title != b.title
  AND a.type = 'Movie'
  AND b.type = 'Movie';

/*
   Insight: The dataset suggests a major content expansion during 2021,
   leading to many titles sharing the same release year.
*/

-- ----------------------------------------------------------

-- Q25. Combine Movies and TV Shows into one result (UNION)
SELECT title, type FROM netflix WHERE type = 'Movie'
UNION
SELECT title, type FROM netflix WHERE type = 'TV Show';

/*
   Insight: The dataset contains both Movies and TV Shows that can be
   analyzed together or separately depending on business needs.
*/


-- ============================================================
-- END OF PROJECT
-- ============================================================
