USE employees;

-- Write a query that shows each department along with the name of the current manager 
-- for that department.

SELECT
	a.dept_name
    ,concat(c.first_name, ' ', c.last_name) AS emp_name

FROM departments AS a

-- This subquery is used to find names of managers that are still employed.
LEFT JOIN 
	(SELECT emp_no, dept_no
     FROM dept_manager 
     WHERE to_date LIKE '9999%')
     AS b
ON a.dept_no = b.dept_no
-- We use the LIKE '9999%' statement as employees that are currently still employed
-- have 9999 listed as the year in the to_date column.

LEFT JOIN employees AS c
ON b.emp_no = c.emp_no

ORDER BY a.dept_name;

-- Find the name of all departments currently managed by women.

SELECT
	a.dept_name
    ,concat(c.first_name, ' ', c.last_name) AS emp_name

FROM departments AS a

-- This subquery is used to find only currently employed managers.
LEFT JOIN 
	(SELECT 
		emp_no
        ,dept_no
     FROM dept_manager 
     WHERE to_date LIKE '9999%')
     AS b
ON a.dept_no = b.dept_no

-- By using the Inner Join below, we are able to only keep women.
INNER JOIN 
	(SELECT 
		emp_no
        ,first_name
        ,last_name
	FROM employees 
    WHERE gender = 'F')
    AS c
ON b.emp_no = c.emp_no

ORDER BY a.dept_name;

-- Find the count of employees by current title currently working in the Customer 
-- Service department.

SELECT
	a.title
    ,COUNT(*) AS count
    
FROM titles AS a

-- This subquery is used to get a list of all current customer service employees.
-- By Inner Joining, we are able to match titles for only those individuals.  
-- We could also right join.
INNER JOIN 
	(
    SELECT a.emp_no
    FROM dept_emp AS a
    LEFT JOIN departments AS b
    ON a.dept_no = b.dept_no
    WHERE 
		b.dept_name = 'Customer Service'
        AND a.to_date LIKE '9999%'
    ) AS b
ON a.emp_no = b.emp_no

WHERE a.to_date LIKE '9999%'

GROUP BY a.title

ORDER BY a.title;

-- Find the current salary of all current managers.

SELECT
	a.dept_name
    ,concat(c.first_name, ' ', c.last_name) AS emp_name
    ,d.salary

FROM departments AS a

LEFT JOIN 
	(SELECT emp_no, dept_no
     FROM dept_manager 
     WHERE to_date LIKE '9999%')
     AS b
ON a.dept_no = b.dept_no

LEFT JOIN employees AS c
ON b.emp_no = c.emp_no

LEFT JOIN 
	(
    SELECT
		emp_no
        ,salary
    FROM salaries
    WHERE to_date LIKE '9999%'
    ) AS d
ON b.emp_no = d.emp_no

ORDER BY a.dept_name;

-- Find the number of employees in each department.

SELECT
    b.dept_name
    ,a.dept_no
    ,COUNT(*)
    
FROM dept_emp AS a

LEFT JOIN departments AS b
ON a.dept_no = b.dept_no

WHERE a.to_date LIKE '9999%'

GROUP BY
	b.dept_name
    ,a.dept_no

ORDER BY
	a.dept_no;
    
-- Which department has the highest average salary?

SELECT
	dept_name
    ,avg_salary AS max_avg_dept_salary

-- Below, we find the highest salary in each department.  At the end, we'll
-- Order By salary DESC and take only the first row, which will be the highest salary.
FROM 
	(
    SELECT
		b.dept_name
        ,AVG(c.salary) AS avg_salary
    
    FROM dept_emp AS a
    
    LEFT JOIN departments AS b
    ON a.dept_no = b.dept_no
    
    LEFT JOIN salaries AS c
    ON a.emp_no = c.emp_no
    
    -- We want to make sure we get the employee's current department 
	-- and current salary.
    WHERE a.to_date LIKE '9999%' AND c.to_date LIKE '9999%'
    
    GROUP BY b.dept_name
    ) AS a

ORDER BY avg_salary DESC

LIMIT 1;

-- Find all the employees with the same hire date as employee 101010.

SELECT
	COUNT(*)

FROM employees

WHERE hire_date =
	(
    SELECT
		hire_date
	FROM employees
    WHERE emp_no = 101010
    );
    
-- Find all the titles held by all employees with the first name Aamod.
SELECT
	DISTINCT(title)
    ,COUNT(*)

FROM titles AS a

INNER JOIN
	(
	SELECT
		emp_no
	FROM employees
	WHERE first_name = 'Aamod'
	) AS b
ON a.emp_no = b.emp_no
GROUP BY title;

-- How many people in the employees table are no longer working for the company?

SELECT
	COUNT(DISTINCT(emp_no))

FROM employees

-- We will create a list of employee numbers that are still employed.
-- Then, we will look for employee numbers not in that last.
WHERE emp_no NOT IN
	(
    SELECT DISTINCT(emp_no) AS still_employed
    FROM salaries
    WHERE to_date LIKE '9999%'
    );
    
-- Find all the employees that currently have a higher than average salary.

SELECT
	CONCAT(b.first_name, ' ', b.last_name) AS employee
    ,a.salary AS salary

FROM 
	(
    SELECT
		emp_no
		,salary
    FROM salaries
    WHERE to_date LIKE '9999%'
    ) AS a

LEFT JOIN employees AS b
ON a.emp_no = b.emp_no

WHERE a.salary >
	(
    SELECT AVG(salary) AS avg_salary
    FROM salaries
    WHERE to_date LIKE '9999%'
    );
    
--  How much do the current managers of each department get paid, 
--  relative to the average salary for the department? Is there any 
--  department where the department manager gets paid less than the 
--  average salary?

SELECT
	dept_avg_salary.dept_name
    ,ROUND(dept_avg_salary.dept_avg_salary,2) AS dept_avg_salary
    ,mgr_salary.mgr_salary
    ,ROUND((mgr_salary.mgr_salary-dept_avg_salary.dept_avg_salary),2) AS mgr_sal_to_avg
    
FROM(
	SELECT
		a.dept_name
		,AVG(b.salary) AS dept_avg_salary

	FROM(
		SELECT
			a.emp_no
			,a.dept_no
			,b.dept_name
			
		FROM dept_emp AS a

		LEFT JOIN departments AS b
		ON a.dept_no = b.dept_no
		
		WHERE a.to_date LIKE '9999%'
		) AS a
		
	LEFT JOIN(
		SELECT 
			emp_no
			,salary
			
		FROM salaries
		
		WHERE to_date LIKE '9999%'
		) AS b
	ON a.emp_no = b.emp_no

	GROUP BY a.dept_name
    ) AS dept_avg_salary

LEFT JOIN(
	SELECT 
		a.emp_no
		,c.dept_name
		,b.salary AS mgr_salary
	FROM dept_manager AS a

	LEFT JOIN salaries AS b
	ON a.emp_no = b.emp_no

	LEFT JOIN departments AS c
	ON a.dept_no = c.dept_no

	WHERE a.to_date LIKE '9999%' and b.to_date LIKE '9999%'
    ) AS mgr_salary
ON dept_avg_salary.dept_name = mgr_salary.dept_name

ORDER BY dept_avg_salary.dept_name