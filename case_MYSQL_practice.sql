-- Write a query that returns all employee names, and a new column 
-- 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the 
-- first letter of their last name.

SELECT
	CONCAT(first_name, ' ', last_name) AS emp_name
    ,CASE 
		WHEN LEFT(last_name, 1) <= 'H' THEN 'A-H'
		WHEN LEFT(last_name, 1) BETWEEN 'I' AND 'Q' THEN 'I-Q'
		WHEN LEFT(last_name, 1) >= 'R' THEN 'R-Z'
        ELSE 'Is that a $?'
	END AS alpha_group

FROM employees;

-- How many employees were born in each decade?

SELECT
	SUBSTR(birth_date, 3, 1) AS birth_decade
    ,COUNT(*)

FROM employees

GROUP BY birth_decade;

-- We can also do a count by each birth year.

SELECT 
	SUBSTRING_INDEX(birth_date, '-', 1) AS birth_year
    ,COUNT(*)
    
FROM employees

GROUP BY birth_year

ORDER BY birth_year;