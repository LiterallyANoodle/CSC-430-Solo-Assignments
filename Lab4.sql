USE company;
SET SQL_SAFE_UPDATES = 0;

# Create a stored procedure to retrieve SSN, first name, last name, and salary for the employees belonging to the department, given the department name.
DROP PROCEDURE IF EXISTS lab_4_question_1;
DELIMITER $$
CREATE PROCEDURE lab_4_question_1 (IN dept_name varchar(25))
	BEGIN
		SELECT e.fname, e.lname, e.salary
		FROM employee e, department d
		WHERE (e.dno = d.dnumber AND d.dname = dept_name);
    END$$
DELIMITER ;

# test
CALL lab_4_question_1('Research');

# Create a stored procedure to update supervisor for a specified employee, given employee SSN and then new supervisor SSN.
DROP PROCEDURE IF EXISTS lab_4_question_2;
DELIMITER $$
CREATE PROCEDURE lab_4_question_2 (IN employee_ssn varchar(9), IN new_supervisor_ssn varchar(9))
	BEGIN
		UPDATE employee e
		SET e.super_ssn = new_supervisor_ssn
        WHERE (e.ssn = employee_ssn);
    END$$
DELIMITER ;

# test
DELETE FROM employee WHERE (employee.ssn = 999999999);
INSERT INTO employee VALUES ("TestyMcTestFace", "T", "TestyMcTestFace", '999999999', "1999-01-01", "Address", "M", 500, '888665555', 1);
CALL lab_4_question_2(999999999, 333445555);

# Create a stored procedure to retrieve a list of all employees whose salary is above the average salary in their department.
DROP PROCEDURE IF EXISTS lab_4_question_3;
DELIMITER $$
CREATE PROCEDURE lab_4_question_3 ()
	BEGIN
        SELECT *
		FROM employee e, (
			SELECT e.dno, AVG(e.salary) AS avg_salary
            FROM employee e
            GROUP BY e.dno
        ) AS avg_dept_salaries
		WHERE (e.dno = avg_dept_salaries.dno AND e.salary > avg_dept_salaries.avg_salary);
    END$$
DELIMITER ;

# test 
CALL lab_4_question_3();

# Create a function to calculate the age of an employee spouse, given the employee SSN.
DROP FUNCTION IF EXISTS lab_4_question_4;
DELIMITER $$
CREATE FUNCTION lab_4_question_4 (employee_ssn varchar(9))
RETURNS int DETERMINISTIC
	BEGIN
		DECLARE employee_spouse_bdate date; # assuming they have only one spouse lol
        DECLARE today date;
        
        SET today = CURDATE();
        
        SELECT d.bdate 
        INTO employee_spouse_bdate
        FROM dependent d
        WHERE (d.essn = employee_ssn AND d.relationship = 'spouse');
        
        RETURN TIMESTAMPDIFF(YEAR, employee_spouse_bdate, today);
    END$$
DELIMITER ;

# test 
SELECT lab_4_question_4(999999999); # no spouse
SELECT lab_4_question_4(123456789); # has spouse

# Create a function to calculate and average salary of all employees who work for a department, given the department name.
DROP FUNCTION IF EXISTS lab_4_question_5;
DELIMITER $$
CREATE FUNCTION lab_4_question_5 (dept_name varchar(25))
RETURNS decimal(10,2) DETERMINISTIC
	BEGIN
		DECLARE department_number int;
        
        SELECT d.dnumber
        INTO department_number
        FROM department d
        WHERE (d.dname = dept_name);
    
		RETURN (
			SELECT AVG(e.salary)
            FROM employee e
            WHERE (e.dno = department_number)
        );
    END$$
DELIMITER ;

# test 
SELECT lab_4_question_5('Research');

# cleanup
SET SQL_SAFE_UPDATES = 1;