CREATE OR ALTER PROCEDURE drop_bank
AS 
BEGIN
	-- foreign keys
	ALTER TABLE employee DROP CONSTRAINT Employee_Department;

	ALTER TABLE branch DROP CONSTRAINT branch_employee;

	ALTER TABLE career_timeline DROP CONSTRAINT career_timeline_department;

	ALTER TABLE career_timeline DROP CONSTRAINT career_timeline_employee;

	ALTER TABLE career_timeline DROP CONSTRAINT career_timeline_manager;

	ALTER TABLE employee DROP CONSTRAINT employee_branch;

	ALTER TABLE employee DROP CONSTRAINT employee_manager;

	ALTER TABLE department DROP CONSTRAINT parent_dept;

	-- tables
	DROP TABLE branch;

	DROP TABLE career_timeline;

	DROP TABLE department;

	DROP TABLE employee;

	-- End of file.
END


