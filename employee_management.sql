-- Employee Management System
-- Portable SQL schema (PostgreSQL, MySQL 8+, and SQL Server with minor
-- identity/auto-increment syntax adjustments).

CREATE TABLE department (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(150),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(25),
    job_title VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(12, 2) NOT NULL CHECK (salary >= 0),
    manager_id INTEGER,
    employment_status VARCHAR(20) NOT NULL DEFAULT 'Active'
        CHECK (employment_status IN ('Active', 'On Leave', 'Inactive')),
    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id) REFERENCES department (department_id),
    CONSTRAINT fk_employee_manager
        FOREIGN KEY (manager_id) REFERENCES employees (employee_id),
    CONSTRAINT chk_employee_not_self_manager
        CHECK (manager_id IS NULL OR manager_id <> employee_id)
);

CREATE TABLE project (
    project_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_name VARCHAR(150) NOT NULL UNIQUE,
    description VARCHAR(500),
    start_date DATE NOT NULL,
    end_date DATE,
    project_status VARCHAR(20) NOT NULL DEFAULT 'Planned'
        CHECK (project_status IN ('Planned', 'Active', 'Completed', 'Cancelled')),
    CONSTRAINT chk_project_dates
        CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE emp_projects (
    employee_id INTEGER NOT NULL,
    project_id INTEGER NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
    hours_per_week DECIMAL(5, 2) CHECK (hours_per_week >= 0 AND hours_per_week <= 168),
    CONSTRAINT pk_emp_projects PRIMARY KEY (employee_id, project_id),
    CONSTRAINT fk_emp_projects_employee
        FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_emp_projects_project
        FOREIGN KEY (project_id) REFERENCES project (project_id)
        ON DELETE CASCADE
);

CREATE INDEX idx_employees_department_id ON employees (department_id);
CREATE INDEX idx_employees_manager_id ON employees (manager_id);
CREATE INDEX idx_emp_projects_project_id ON emp_projects (project_id);

-- ================================================================
-- Sample data
-- Insert order: departments -> employees -> projects -> assignments.
-- On a new database, identity values start at 1, so the references below
-- correspond to the insertion order in each table.
-- ================================================================

INSERT INTO department (department_name, location) VALUES
    ('Human Resources', 'New York'),
    ('Information Technology', 'Bengaluru'),
    ('Finance', 'London'),
    ('Marketing', 'Singapore'),
    ('Operations', 'Chicago');

INSERT INTO employees
    (department_id, first_name, last_name, email, phone, job_title,
     hire_date, salary, manager_id, employment_status)
VALUES
    (1, 'Olivia', 'Brown', 'olivia.brown@example.com', '+1-555-0101', 'HR Manager', '2018-01-15', 85000.00, NULL, 'Active'),
    (2, 'Liam', 'Smith', 'liam.smith@example.com', '+91-555-0102', 'IT Director', '2017-03-20', 125000.00, NULL, 'Active'),
    (3, 'Emma', 'Davis', 'emma.davis@example.com', '+44-555-0103', 'Finance Manager', '2019-05-10', 98000.00, NULL, 'Active'),
    (4, 'Noah', 'Wilson', 'noah.wilson@example.com', '+65-555-0104', 'Marketing Manager', '2020-02-03', 92000.00, NULL, 'Active'),
    (5, 'Ava', 'Taylor', 'ava.taylor@example.com', '+1-555-0105', 'Operations Manager', '2018-09-17', 95000.00, NULL, 'Active'),
    (2, 'Ethan', 'Moore', 'ethan.moore@example.com', '+91-555-0106', 'Senior Developer', '2020-06-01', 90000.00, 2, 'Active'),
    (2, 'Sophia', 'Anderson', 'sophia.anderson@example.com', '+91-555-0107', 'Database Administrator', '2021-01-11', 88000.00, 2, 'Active'),
    (2, 'Mason', 'Thomas', 'mason.thomas@example.com', '+91-555-0108', 'Systems Analyst', '2022-04-18', 72000.00, 2, 'Active'),
    (2, 'Isabella', 'Jackson', 'isabella.jackson@example.com', '+91-555-0109', 'Software Developer', '2023-02-13', 68000.00, 6, 'Active'),
    (1, 'James', 'White', 'james.white@example.com', '+1-555-0110', 'Recruiter', '2021-07-26', 62000.00, 1, 'Active'),
    (3, 'Mia', 'Harris', 'mia.harris@example.com', '+44-555-0111', 'Financial Analyst', '2022-03-07', 67000.00, 3, 'Active'),
    (3, 'Benjamin', 'Martin', 'benjamin.martin@example.com', '+44-555-0112', 'Accountant', '2021-11-15', 65000.00, 3, 'Active'),
    (4, 'Charlotte', 'Thompson', 'charlotte.thompson@example.com', '+65-555-0113', 'Content Strategist', '2022-08-22', 64000.00, 4, 'Active'),
    (4, 'Lucas', 'Garcia', 'lucas.garcia@example.com', '+65-555-0114', 'Brand Specialist', '2023-01-09', 61000.00, 4, 'Active'),
    (4, 'Amelia', 'Martinez', 'amelia.martinez@example.com', '+65-555-0115', 'Marketing Analyst', '2023-06-12', 59000.00, 4, 'On Leave'),
    (5, 'Henry', 'Robinson', 'henry.robinson@example.com', '+1-555-0116', 'Operations Analyst', '2020-10-05', 70000.00, 5, 'Active'),
    (5, 'Harper', 'Clark', 'harper.clark@example.com', '+1-555-0117', 'Process Engineer', '2021-05-24', 76000.00, 5, 'Active'),
    (5, 'Alexander', 'Rodriguez', 'alexander.rodriguez@example.com', '+1-555-0118', 'Quality Specialist', '2022-09-19', 63000.00, 5, 'Active'),
    (5, 'Evelyn', 'Lewis', 'evelyn.lewis@example.com', '+1-555-0119', 'Logistics Coordinator', '2023-03-27', 58000.00, 5, 'Active'),
    (2, 'Daniel', 'Lee', 'daniel.lee@example.com', '+91-555-0120', 'DevOps Engineer', '2024-01-08', 79000.00, 6, 'Active');

INSERT INTO project
    (project_name, description, start_date, end_date, project_status)
VALUES
    ('Employee Portal', 'Self-service employee management portal', '2024-01-15', NULL, 'Active'),
    ('Cloud Migration', 'Migration of infrastructure to the cloud', '2024-02-01', NULL, 'Active'),
    ('Annual Budget 2025', 'Annual financial planning and budgeting', '2024-07-01', '2024-12-15', 'Completed'),
    ('Brand Refresh', 'Company brand and visual identity refresh', '2024-03-01', '2024-09-30', 'Completed'),
    ('Warehouse Automation', 'Automation of warehouse workflows', '2024-04-15', NULL, 'Active'),
    ('Cybersecurity Upgrade', 'Security controls and monitoring upgrade', '2024-05-01', NULL, 'Active'),
    ('Customer Analytics', 'Customer data and reporting initiative', '2024-06-10', NULL, 'Active'),
    ('Recruitment Drive', 'Hiring initiative for the next business year', '2024-08-01', '2024-11-30', 'Completed'),
    ('Process Optimization', 'Review and improvement of operational processes', '2024-09-01', NULL, 'Planned'),
    ('Mobile App', 'Mobile application for employee services', '2024-10-01', NULL, 'Planned');

INSERT INTO emp_projects
    (employee_id, project_id, role_name, assigned_date, hours_per_week)
VALUES
    (2, 1, 'Project Sponsor', '2024-01-15', 4),
    (6, 1, 'Technical Lead', '2024-01-15', 20),
    (9, 1, 'Application Developer', '2024-01-20', 30),
    (20, 1, 'DevOps Engineer', '2024-02-01', 16),
    (2, 2, 'Project Sponsor', '2024-02-01', 4),
    (6, 2, 'Cloud Architect', '2024-02-01', 24),
    (20, 2, 'DevOps Engineer', '2024-02-01', 32),
    (3, 3, 'Project Sponsor', '2024-07-01', 8),
    (11, 3, 'Financial Analyst', '2024-07-01', 24),
    (12, 3, 'Accountant', '2024-07-01', 20),
    (4, 4, 'Project Sponsor', '2024-03-01', 6),
    (13, 4, 'Content Strategist', '2024-03-01', 24),
    (14, 4, 'Brand Specialist', '2024-03-01', 24),
    (5, 5, 'Project Sponsor', '2024-04-15', 6),
    (17, 5, 'Process Engineer', '2024-04-15', 28),
    (18, 5, 'Quality Specialist', '2024-04-15', 16),
    (6, 6, 'Technical Lead', '2024-05-01', 12),
    (7, 6, 'Security Database Lead', '2024-05-01', 20),
    (11, 7, 'Data Analyst', '2024-06-10', 20),
    (13, 7, 'Content Analyst', '2024-06-10', 12),
    (1, 8, 'Project Sponsor', '2024-08-01', 4),
    (10, 8, 'Recruiter', '2024-08-01', 30),
    (5, 9, 'Project Sponsor', '2024-09-01', 6),
    (16, 9, 'Operations Analyst', '2024-09-01', 24),
    (19, 9, 'Logistics Coordinator', '2024-09-01', 16),
    (2, 10, 'Project Sponsor', '2024-10-01', 4),
    (8, 10, 'Systems Analyst', '2024-10-01', 20),
    (20, 10, 'DevOps Engineer', '2024-10-01', 12);
