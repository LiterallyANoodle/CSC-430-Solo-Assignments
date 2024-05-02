USE company;
SET SQL_SAFE_UPDATES = 0;

# Write a trigger to create a default department location in Bellaire every time new department is inserted into database.
# multiple runs
DROP TRIGGER IF EXISTS company.question_one;

# code
DELIMITER $$
CREATE TRIGGER question_one
AFTER INSERT ON department
FOR EACH ROW
BEGIN
	INSERT INTO dept_locations
    VALUES (NEW.dnumber, 'Bellaire');
END$$
DELIMITER ;

# test 1
DELETE FROM dept_locations WHERE (dept_locations.dnumber = 9999);
DELETE FROM department WHERE (department.dnumber = 9999);
INSERT INTO department VALUES ("Test", 9999, 123456789, '1999-01-01');

# Write a trigger to enforce following constraint: employee salary must not be higher than the salary of his/her direct supervisor. If it is, then display message – “Please, provide correct value for the employee salary".
# multiple runs 
DROP TRIGGER IF EXISTS company.question_two;

# code
DELIMITER $$
CREATE TRIGGER question_two
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN 
	DECLARE mgr_salary DECIMAL(10,2);
    SET mgr_salary = (SELECT e.salary FROM employee e WHERE (e.ssn = NEW.super_ssn));
    
	IF (NEW.salary > @mgr_salary) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please, provide correct value for the employee salary';
    END IF;
END$$
DELIMITER ;

# test
-- DELETE FROM employee WHERE (employee.ssn = 999999999);
-- INSERT INTO employee VALUES ("TestyMcTestFace", "T", "TestyMcTestFace", 999999999, "1999-01-01", "Address", "M", 9999999, 333445555, 5);

# Write a trigger to update supervisor SSN of an employee with the SSN of the department manager where he/she works before inserting the record into employee table if the supervisor SSN attribute is empty or NULL.
# multiple runs 
DROP TRIGGER IF EXISTS company.question_three;

# code
DELIMITER $$
CREATE TRIGGER question_three
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN 
	DECLARE dept_mgr_ssn VARCHAR(9);
    SET dept_mgr_ssn = (SELECT d.mgr_ssn FROM department d WHERE (NEW.dno = d.dnumber));
    
    IF (NEW.super_ssn IS NULL OR NEW.super_ssn = '') THEN
		SET NEW.super_ssn = dept_mgr_ssn;
    END IF;
END$$
DELIMITER ;

# test
DELETE FROM employee WHERE (employee.ssn = 999999999);
INSERT INTO employee VALUES ("TestyMcTestFace", "T", "TestyMcTestFace", 999999999, "1999-01-01", "Address", "M", 500, NULL, 1);

# Create a view that displays first name, last name, SSN, salary, department name and department number for each department manager.
# multiple runs
DROP VIEW IF EXISTS question_four;

# code
CREATE VIEW question_four AS
	SELECT e.fname, e.lname, e.ssn, e.salary, d.dname, d.dnumber
    FROM employee e, department d
    WHERE (e.dno = d.dnumber AND e.ssn = d.mgr_ssn);
    
# test 
SELECT * FROM question_four; 

# Create a view that displays project number, project name, controlling department number, controlling department name, total number of employees, total salary paid, and total hours worked for each project.
# multiple runs 
DROP VIEW IF EXISTS question_five;

# code
CREATE VIEW question_five AS 
	SELECT 
		aggregates.project_number, 
        p.pname AS project_name, 
        d.dnumber AS dept_number, 
        d.dname AS dept_name, 
        aggregates.total_employees, 
        aggregates.total_salary, 
        aggregates.total_hours
	FROM (
		SELECT 
			w.pno AS project_number, 
            COUNT(w.essn) AS total_employees, 
            SUM(e.salary) AS total_salary, 
            SUM(w.hours) AS total_hours
		FROM employee e, works_on w
		WHERE (w.essn = e.ssn)
		GROUP BY (w.pno)
    ) AS aggregates, project p, department d
    WHERE (p.pnumber = aggregates.project_number AND p.dnum = d.dnumber);

# test
SELECT * FROM question_five;

# cleanup
SET SQL_SAFE_UPDATES = 1;