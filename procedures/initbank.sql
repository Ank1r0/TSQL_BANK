CREATE OR ALTER PROCEDURE init_bank
AS
BEGIN


-- tables
-- Table: branch
CREATE TABLE branch (
    branch_id int  NOT NULL,
    branch_number varchar(10)  UNIQUE NOT NULL ,
    branch_name varchar(100)  NOT NULL,
    city varchar(50)  NOT NULL,
    state_province varchar(50)  NOT NULL,
    branch_manager_id int  NOT NULL,
    CONSTRAINT branch_pk PRIMARY KEY  (branch_id)
);

-- Table: career_timeline
CREATE TABLE career_timeline (
    history_id int  NOT NULL,
    emp_id int  NOT NULL,
    dept_id int  NOT NULL,
    manager_id int  NULL,
    salary decimal(15,2)  NOT NULL,
    effective_date date  NOT NULL,
    change_reason varchar(255)  NOT NULL,
    CONSTRAINT career_timeline_pk PRIMARY KEY  (history_id)
);

-- Table: department
CREATE TABLE department (
    dept_id int  NOT NULL,
    dept_name varchar(50)  NOT NULL,
    building_floor varchar(50)  NOT NULL,
    dubget_annual decimal(18,6)  NOT NULL,
    parent_dept_id int  NULL,
    CONSTRAINT department_pk PRIMARY KEY  (dept_id)
);

-- Table: employee
CREATE TABLE employee (
    emp_id int  NOT NULL,
    first_name varchar(50)  NOT NULL,
    second_name varchar(50)  NOT NULL,
    email varchar(50)  NOT NULL,
    phone_number varchar(50)  NOT NULL,
    hire_date date  NOT NULL,
    job_level int  NOT NULL,
    salary decimal(15,2)  NOT NULL,
    dept_id int  NOT NULL,
    branch_id int  NOT NULL,
    manager_id int  NULL,
    status int  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY  (emp_id)
);

-- foreign keys
-- Reference: Employee_Department (table: employee)
ALTER TABLE employee ADD CONSTRAINT Employee_Department
    FOREIGN KEY (dept_id)
    REFERENCES department (dept_id);

-- Reference: branch_employee (table: branch)
ALTER TABLE branch ADD CONSTRAINT branch_employee
    FOREIGN KEY (branch_manager_id)
    REFERENCES employee (emp_id);

-- Reference: career_timeline_department (table: career_timeline)
ALTER TABLE career_timeline ADD CONSTRAINT career_timeline_department
    FOREIGN KEY (dept_id)
    REFERENCES department (dept_id);

-- Reference: career_timeline_employee (table: career_timeline)
ALTER TABLE career_timeline ADD CONSTRAINT career_timeline_employee
    FOREIGN KEY (emp_id)
    REFERENCES employee (emp_id);

-- Reference: career_timeline_manager (table: career_timeline)
ALTER TABLE career_timeline ADD CONSTRAINT career_timeline_manager
    FOREIGN KEY (manager_id)
    REFERENCES employee (emp_id);

-- Reference: employee_branch (table: employee)
ALTER TABLE employee ADD CONSTRAINT employee_branch
    FOREIGN KEY (branch_id)
    REFERENCES branch (branch_id);

-- Reference: employee_manager (table: employee)
ALTER TABLE employee ADD CONSTRAINT employee_manager
    FOREIGN KEY (manager_id)
    REFERENCES employee (emp_id);

-- Reference: parent_dept (table: department)
ALTER TABLE department ADD CONSTRAINT parent_dept
    FOREIGN KEY (parent_dept_id)
    REFERENCES department (dept_id);

-- End of file.


END
