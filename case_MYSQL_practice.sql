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
	-- This Substring is used to take the third digit from the employee's birth
    -- year, which is the decadel  We can then group by that to get a count of
    -- employees born in each decade.
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

-- Create a table with all current employee numbers, all of their salaries, and a
-- new column that can be used as a flag for whether or not the salary is listed
-- is the current salary of the employee.

SELECT
	a.emp_no
    ,b.salary
    ,IF(to_date LIKE '9999%', true, false) AS current_salary
    
FROM 
	(
	SELECT emp_no
    FROM dept_emp
    WHERE to_date LIKE '9999%'
    ) AS a
    
LEFT JOIN salaries AS b
ON a.emp_no = b.emp_no

ORDER BY emp_no, salary DESC;

-- Write a query that returns all employees (emp_no), their department number, 
-- their start date, their end date, and a new column 'is_current_employee' 
-- that is a 1 if the employee is still with the company and 0 if not.

SELECT 
	a.*
    ,IF(to_date LIKE '9999%', 1, 0) AS is_current_employer
    
FROM dept_emp AS a

INNER JOIN 
-- This subquery is used to create a list of an employee's most recent dept.
-- By Inner Joining back to the dept_emp table, we eliminate rows that are not
-- an employee's most recent department.
	(
	SELECT 
		emp_no
		,MAX(from_date) AS most_rec_dept_date
	FROM dept_emp
	GROUP BY emp_no
	) AS b 
ON a.emp_no = b.emp_no AND a.from_date = b.most_rec_dept_date

ORDER BY a.emp_no
