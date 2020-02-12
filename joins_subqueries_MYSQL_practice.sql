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
