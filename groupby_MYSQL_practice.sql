-- Find the unique titles in the titles table.
SELECT
	DISTINCT(title)

FROM titles

ORDER BY title;

-- Find the unique employees whose last names start and end with 'E'.

SELECT
	DISTINCT(last_name)
    
FROM employees

WHERE last_name LIKE 'e%e'

ORDER BY last_name;

-- Update your previous query to now find unique combinations of first and last name 
-- where the last name starts and ends with 'E'.
SELECT
	DISTINCT(last_name)
    ,first_name
    
FROM employees

WHERE last_name LIKE 'e%e'

ORDER BY last_name;

-- Find the unique last names with a 'q' but not 'qu'.
SELECT 
	DISTINCT(last_name)

FROM employees

WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%'

ORDER BY last_name;

-- Add a COUNT() to your results and use ORDER BY to make it easier to find 
-- employees whose unusual name is shared with others.
SELECT 
	last_name
    ,COUNT(last_name)

FROM employees

WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%'

GROUP BY last_name

ORDER BY COUNT(last_name) DESC;

-- Find the count of employees by gender with a first name of 
-- 'Irena', 'Vidya', or 'Maya'.
SELECT 
	gender
	,COUNT(*)
    
FROM employees

WHERE first_name IN ('Irena', 'Vidya', 'Maya')

GROUP BY gender;

-- Recall the query the generated usernames for the employees from the functions lesson. 
-- Are there any duplicate usernames?
SELECT 
	LOWER(CONCAT(
		SUBSTRING(first_name, 1, 1)
        ,SUBSTRING(last_name, 1, 4)
        ,'_'
        ,SUBSTRING(birth_date, 6, 2)
        ,SUBSTRING(birth_date, 3,2)
        )) AS username
	,COUNT(*)
FROM employees

GROUP BY username

HAVING COUNT(username) > 1;

--  Bonus: How many duplicate usernames are there?
SELECT
	COUNT(a.username)
    
FROM(
	SELECT 
		LOWER(CONCAT(
			SUBSTRING(first_name, 1, 1)
			,SUBSTRING(last_name, 1, 4)
			,'_'
			,SUBSTRING(birth_date, 6, 2)
			,SUBSTRING(birth_date, 3,2)
			)) AS username

	FROM employees

	GROUP BY username

	HAVING COUNT(username) > 1) AS a;