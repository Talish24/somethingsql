# Employee Management System ER Diagram

```mermaid
erDiagram
    DEPARTMENT ||--o{ EMPLOYEES : contains
    EMPLOYEES ||--o{ EMPLOYEES : manages
    EMPLOYEES ||--o{ EMP_PROJECTS : assigned_to
    PROJECT ||--o{ EMP_PROJECTS : includes

    DEPARTMENT {
        int department_id PK
        varchar department_name UK
        varchar location
        timestamp created_at
    }

    EMPLOYEES {
        int employee_id PK
        int department_id FK
        int manager_id FK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone
        varchar job_title
        date hire_date
        decimal salary
        varchar employment_status
    }

    PROJECT {
        int project_id PK
        varchar project_name UK
        varchar description
        date start_date
        date end_date
        varchar project_status
    }

    EMP_PROJECTS {
        int employee_id PK, FK
        int project_id PK, FK
        varchar role_name
        date assigned_date
        decimal hours_per_week
    }
```

## Relationships

- One `department` has many `employees`.
- One employee may manage many employees; `manager_id` is a self-referencing foreign key.
- Employees and projects have a many-to-many relationship through `emp_projects`.
- The composite primary key `(employee_id, project_id)` prevents duplicate assignments.

## Primary keys

| Table | Primary key |
|---|---|
| `department` | `department_id` |
| `employees` | `employee_id` |
| `project` | `project_id` |
| `emp_projects` | `(employee_id, project_id)` |

## Foreign keys

| Table | Column | References |
|---|---|---|
| `employees` | `department_id` | `department(department_id)` |
| `employees` | `manager_id` | `employees(employee_id)` |
| `emp_projects` | `employee_id` | `employees(employee_id)` |
| `emp_projects` | `project_id` | `project(project_id)` |
