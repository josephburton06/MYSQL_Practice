-- Search for employees whose names start and end with 'E'. 
-- Combine their first and last name together as a single column named full_name.
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name

FROM employees

WHERE first_name LIKE 'e%'

ORDER BY first_name;

-- Convert the names produced in your last query to all uppercase.
SELECT 
	UPPER(CONCAT(first_name, ' ', last_name)) AS full_name

FROM employees

WHERE first_name LIKE 'e%'

ORDER BY first_name;

-- Find employees born on Christmas and hired in the 90s, use datediff() 
-- to find how many days they have been working at the company.
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name
    ,hire_date
    ,datediff(curdate(), hire_date) AS days_employed

FROM employees AS a

WHERE birth_date LIKE '%-12-25' AND hire_date LIKE '199%'

ORDER BY days_employed, last_name; 


-- Find the smallest and largest salary from the salaries table.
SELECT 
    MIN(salary) AS min_salary
    ,MAX(salary) AS max_salary

FROM salaries;

-- Generate a username for all of the employees. 
-- A username should be all lowercase, and consist of the first character of the 
-- employees first name, the first 4 characters of the employees last name, 
-- an underscore, the month the employee was born, and the last two digits of the 
-- year that they were born. 

SELECT 
	LOWER(CONCAT(
		SUBSTRING(first_name, 1, 1)
        ,SUBSTRING(last_name, 1, 4)
        ,'_'
        ,SUBSTRING(birth_date, 6, 2)
        ,SUBSTRING(birth_date, 3,2)
        )) AS username

FROM employees;

