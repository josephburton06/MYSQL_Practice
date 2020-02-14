USE employees;

-- Write a query that shows each department along with the name of the current manager 
-- for that department.

SELECT
	a.dept_name
    ,concat(c.first_name, ' ', c.last_name) AS emp_name

FROM departments AS a

LEFT JOIN 
	(SELECT emp_no, dept_no
     FROM dept_manager 
     WHERE to_date LIKE '9999%')
     AS b
ON a.dept_no = b.dept_no

LEFT JOIN employees AS c
ON b.emp_no = c.emp_no

ORDER BY a.dept_name;

-- Find the name of all departments currently managed by women.

SELECT
	a.dept_name
    ,concat(c.first_name, ' ', c.last_name) AS emp_name

FROM departments AS a

LEFT JOIN 
	(SELECT 
		emp_no
        ,dept_no
     FROM dept_manager 
     WHERE to_date LIKE '9999%')
     AS b
ON a.dept_no = b.dept_no

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