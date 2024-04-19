USE company;

# Retrieve first name, last name, and date of birth of all female employees with salary more than 20000.
SELECT fname, lname, bdate
FROM (employee)
WHERE (salary > 20000);

# Retrieve project names and project locations of all projects that belong to the Headquarters department.
SELECT pname, plocation
FROM (project)
WHERE (dnum = 1);

# Retrieve first name, last name, SSN, and salary of employees who manage departments with projects located in Sugarland.
SELECT fname, lname, ssn, salary
FROM (employee e, department d, project p)
WHERE (e.ssn = d.mgr_ssn AND d.dnumber = p.dnum AND p.plocation = 'Sugarland');

# Retrieve name, date of birth, and relationship of all male dependents of employees who work for department 4.
SELECT d.dependent_name, d.bdate, d.relationship
FROM (employee e, dependent d)
WHERE (e.ssn = d.essn AND e.dno = 4);

# Retrieve first name, last name, and date of birth of all employees who work more than 10 hours on project number 30.
SELECT fname, lname, bdate
FROM (employee e, works_on w)
WHERE (e.ssn = w.essn AND w.pno = 30 AND w.hours > 10);
