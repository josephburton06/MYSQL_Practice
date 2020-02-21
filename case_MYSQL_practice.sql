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

FROM employees
