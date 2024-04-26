select *
from books;

-- Check for null values by counting missing values in each column
SELECT
    COUNT(CASE WHEN bookID IS NULL THEN 1 END) AS missing_bookID,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS missing_title,
    COUNT(CASE WHEN authors IS NULL THEN 1 END) AS missing_authors,
    COUNT(CASE WHEN average_rating IS NULL THEN 1 END) AS missing_average_rating,
    COUNT(CASE WHEN isbn IS NULL THEN 1 END) AS missing_isbn,
    COUNT(CASE WHEN isbn13 IS NULL THEN 1 END) AS missing_isbn13,
    COUNT(CASE WHEN language_code IS NULL THEN 1 END) AS missing_language_code,
    COUNT(CASE WHEN num_pages IS NULL THEN 1 END) AS missing_num_pages,
    COUNT(CASE WHEN ratings_count IS NULL THEN 1 END) AS missing_ratings_count,
    COUNT(CASE WHEN text_reviews_count IS NULL THEN 1 END) AS missing_text_reviews_count,
    COUNT(CASE WHEN publication_date IS NULL THEN 1 END) AS missing_publication_date,
    COUNT(CASE WHEN publisher IS NULL THEN 1 END) AS missing_publisher
FROM books; 

SELECT COUNT(*) AS duplicate_count
FROM (
    SELECT *
    FROM books
    GROUP BY bookid
    HAVING COUNT(bookid) > 1
) AS duplicates;


-- Add a new column to store the extracted year
ALTER TABLE books
ADD COLUMN publication_year INT;

-- Update the new column with the extracted year
UPDATE books
SET publication_year = CAST(SUBSTR(publication_date, LENGTH(publication_date) - 3) AS INT);

--Counting Unique Languages in our library
SELECT COUNT(DISTINCT language_code) AS unique_languages_count
FROM books;

--Identifying Most Prevalent Languages
 SELECT language_code, COUNT(*) AS language_count
   FROM books
   GROUP BY language_code
   ORDER BY language_count DESC
   LIMIT 5
   

--Earliest Publication Year
 SELECT MIN(publication_year) AS earliest_publication_year
   FROM books
   
--lets find books that have publication year less than 4 digits   
 select *
   from books 
   where publication_year <1000

-- Update Streetcar Suburbs publication year
UPDATE books
SET publication_year = 1962
WHERE title = 'Streetcar Suburbs: The Process of Growth in Boston  1870-1900';

-- Update The Tolkien Fan's Medieval Reader publication year
UPDATE books
SET publication_year = 2004
WHERE title = 'The Tolkien Fan''s Medieval Reader';

-- Update Patriots publication year
UPDATE books
SET publication_year = 2009
WHERE title = 'Patriots (The Coming Collapse)';

-- Update Brown's Star Atlas publication year using its bookid
UPDATE books
SET publication_year = 1904
WHERE bookid = 8980

--Earliest Publication Year
 SELECT MIN(publication_year) AS earliest_publication_year
   FROM books

 --Latest Publication Year:
 SELECT MAX(publication_year) AS latest_publication_year
   FROM books;
   
   
 --Mean, Min, Max Ratings
  SELECT 
       AVG(average_rating) AS mean_rating,
       MIN(average_rating) AS min_rating,
       MAX(average_rating) AS max_rating
   FROM books;

SELECT *
FROM books
WHERE average_rating REGEXP '[^0-9.]';


UPDATE books
-- Merge average rating with authors
SET authors = CONCAT(authors, ' ', average_rating), 
-- Reset average rating to '0' (assuming it's non-null)
    average_rating = '0' 
-- Filter rows with non-numeric average ratings
WHERE average_rating REGEXP '[^0-9.]'; 

--to find the problematic rows
SELECT *
FROM books
WHERE bookID IN (3349, 4703, 5878, 8980);

-- to move the average rating from the isbn column back into the average rating column
UPDATE books
SET average_rating = isbn
WHERE bookID IN (3349, 4703, 5878, 8980);

UPDATE books
SET isbn = isbn13
WHERE bookID IN (3349, 4703, 5878, 8980);

UPDATE books
SET isbn13 = language_code
WHERE bookID IN (3349, 4703, 5878, 8980);

UPDATE books
SET language_code = num_pages
WHERE bookID IN (3349, 4703, 5878, 8980);

UPDATE books
SET num_pages = ratings_count
WHERE bookID IN (3349, 4703, 5878, 8980);

UPDATE books
SET ratings_count = text_reviews_count
WHERE bookID IN (3349, 4703, 5878, 8980);

UPDATE books
SET text_reviews_count = publication_date
WHERE bookID IN (3349, 4703, 5878, 8980);

--Mean, Min, Max Page Counts
SELECT 
       AVG(num_pages) AS mean_pages,
       MIN(num_pages) AS min_pages,
       MAX(num_pages) AS max_pages
   FROM books;

-- popular authors
SELECT authors, COUNT(*) AS book_count
FROM books
GROUP BY authors
ORDER BY book_count DESC
LIMIT 5;

--highest rated books
SELECT title, average_rating
FROM books
ORDER BY average_rating DESC
LIMIT 5;

--count of books published by year
SELECT publication_year, COUNT(*) AS num_books_published
FROM books
GROUP BY publication_year
ORDER BY publication_year;

--Is there a relationship between the length of a book and its rating? 
SELECT
    CASE
        WHEN num_pages <= 100 THEN 'Short'
        WHEN num_pages > 100 AND num_pages <= 300 THEN 'Medium'
        WHEN num_pages > 300 THEN 'Long'
        ELSE 'Unknown'
    END AS book_length_category,
    round(AVG(average_rating), 2) AS avg_rating
FROM
    books
GROUP BY
    CASE
        WHEN num_pages <= 100 THEN 'Short'
        WHEN num_pages > 100 AND num_pages <= 300 THEN 'Medium'
        WHEN num_pages > 300 THEN 'Long'
        ELSE 'Unknown'
    END
ORDER BY
    avg_rating DESC;

-- Retrieve the count of books for each language represented in the library
SELECT
    language_code,
    COUNT(*) AS book_count
FROM books
GROUP BY language_code
ORDER BY book_count DESC;


--publishers with the highest ratings
select publisher, AVG(average_rating) as highest_ratings
from books
group by publisher
order by highest_ratings desc

-- books by J.K. Rowling
SELECT *
FROM books
WHERE authors LIKE '%J.K. Rowling%'
order by average_rating DESC


--books with 'Harry Potter' in the title
SELECT *
FROM books
WHERE title LIKE '%Harry Potter%';

-- temporal analysis of ratings on a yearly basis
 SELECT 
          publication_year,
        Round(AVG(average_rating),2) AS avg_rating
     FROM books
     GROUP BY publication_year
     ORDER BY publication_year;

-- the total number of text reviews for books published in each year.
   SELECT 
          publication_year,
         SUM(text_reviews_count) AS total_text_reviews
     FROM books
     GROUP BY publication_year
     ORDER BY publication_year;

