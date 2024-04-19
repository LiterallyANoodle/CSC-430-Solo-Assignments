DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
USE company;

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
	fname VARCHAR(15) NOT NULL,
	minit CHAR,
	lname VARCHAR(15) NOT NULL,
	ssn VARCHAR(9) NOT NULL,
	bdate DATE,
	address VARCHAR(50),
	sex CHAR,
	salary DECIMAL(10,2) CHECK (salary > 0),
	super_ssn VARCHAR(9),
	dno INTEGER DEFAULT 1,
	CONSTRAINT emp_pk
	PRIMARY KEY (ssn)
);

DROP TABLE IF EXISTS dependent;
CREATE TABLE dependent (
	essn VARCHAR(9) NOT NULL,
	dependent_name VARCHAR(15) NOT NULL,
	sex CHAR,
	bdate DATE,
	relationship VARCHAR(8),
	CONSTRAINT dependent_pk
	PRIMARY KEY (essn,dependent_name)
);

DROP TABLE IF EXISTS department;
CREATE TABLE department (
	dname VARCHAR(25) NOT NULL,
	dnumber INTEGER NOT NULL,
	mgr_ssn VARCHAR(9),
	mgr_start_date DATE,
	CONSTRAINT dept_pk
	PRIMARY KEY (dnumber),
	CONSTRAINT dept_unique
	UNIQUE (dname)
);

DROP TABLE IF EXISTS dept_locations;
CREATE TABLE dept_locations (
	dnumber INTEGER NOT NULL,
	dlocation VARCHAR(15) NOT NULL,
	CONSTRAINT dept_loc_pk
	PRIMARY KEY (dnumber, dlocation)
);

DROP TABLE IF EXISTS project;
CREATE TABLE project (
	pname VARCHAR(25) NOT NULL,
	pnumber INTEGER NOT NULL,
	plocation VARCHAR(15),
	dnum INTEGER,
	CONSTRAINT project_pk
	PRIMARY KEY (pnumber),
	CONSTRAINT project_unique
	UNIQUE (pname)
);

DROP TABLE IF EXISTS works_on;
CREATE TABLE works_on (
	essn VARCHAR(9) NOT NULL,
	pno INTEGER NOT NULL,
	hours DECIMAL(4,1),
	CONSTRAINT works_on_pk
	PRIMARY KEY (essn,pno)
);

# Constraints
ALTER TABLE employee
ADD CONSTRAINT emp_super_fk
	FOREIGN KEY (super_ssn) REFERENCES employee(ssn)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
ADD CONSTRAINT emp_dept_fk
	FOREIGN KEY (Dno) REFERENCES department(dnumber)
		ON DELETE SET NULL
		ON UPDATE CASCADE;
        
ALTER TABLE dependent
ADD CONSTRAINT dependent_fk
	FOREIGN KEY (essn) REFERENCES employee(ssn)
		ON DELETE RESTRICT
		ON UPDATE CASCADE;
        
ALTER TABLE department
ADD CONSTRAINT dept_mgr_fk
	FOREIGN KEY (mgr_ssn) REFERENCES employee(ssn)
		ON DELETE SET NULL
		ON UPDATE CASCADE;
        
ALTER TABLE dept_locations
ADD CONSTRAINT dept_loc_fk
	FOREIGN KEY (dnumber) REFERENCES department(dnumber)
		ON DELETE RESTRICT
		ON UPDATE CASCADE;
        
ALTER TABLE project
ADD CONSTRAINT project_fk
	FOREIGN KEY (dnum) REFERENCES department(dnumber)
		ON DELETE RESTRICT
		ON UPDATE CASCADE;
        
ALTER TABLE works_on
ADD CONSTRAINT works_on_ssn_fk
	FOREIGN KEY (essn) REFERENCES employee(ssn)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
ADD CONSTRAINT works_on_pno_fk
	FOREIGN KEY (pno) REFERENCES project(pnumber)
		ON DELETE RESTRICT
		ON UPDATE CASCADE;