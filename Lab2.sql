USE company;

# Retrieve last name and SSN of employees whose birthday is in June.
SELECT e.lname, e.ssn
FROM (employee e)
WHERE (MONTH(e.bdate) = 6);

# List first name, last name and salary of employees whose salary is greater than the salary of any employee in department 5.
SELECT e.fname, e.lname, e.salary
FROM employee e, 
(
	SELECT MAX(salary) AS sal
	FROM employee
	WHERE (dno = 5)
) AS d5
WHERE (e.salary > d5.sal);

# Show the resulting salaries if every employee working on the ‘ProductY’ project with a salary between $20000 and $45000 is given a 20% raise.
SELECT e.salary * 1.2 AS raise
FROM employee e, project p
WHERE (e.dno = p.dnum AND p.pname = 'ProductY' AND e.salary BETWEEN 20000 AND 45000);

# Retrieve SSNs of all male employees who work on project numbers 1, 2, or 3.
SELECT DISTINCT e.ssn
FROM employee e, project p
WHERE (e.sex = 'M' AND e.dno = p.dnum AND p.pnumber IN (1, 2, 3));

# For each project on which more than two employees work, retrieve project number, project name, and the average salary of employees who work on the project.
SELECT p.pnumber, p.pname, AVG(e.salary) AS avg_salary
FROM employee e, project p
WHERE (e.dno = p.dnum)
GROUP BY p.pnumber
HAVING COUNT(*) > 2;
