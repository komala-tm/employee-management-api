# Employee Management API

A production-style REST API built with Ruby on Rails for managing employees and departments.

This project demonstrates clean API design, PostgreSQL relationships, validations, background job processing with Sidekiq and Redis, and automated testing with RSpec.

## Tech Stack

* Ruby 3.4
* Ruby on Rails 8
* PostgreSQL
* Redis
* Sidekiq
* RSpec
* Docker
* REST API
* API Versioning

## Features

* Employee CRUD APIs
* Department CRUD APIs
* Employee belongs to a Department
* Department has many Employees
* Model validations
* Strong Parameters
* API versioning using `/api/v1`
* JSON API responses
* Validation error handling
* Background job processing using Active Job + Sidekiq
* Redis used as the Sidekiq backend
* Automated tests using RSpec

## API Endpoints

### Departments

```text
GET    /api/v1/departments
GET    /api/v1/departments/:id
POST   /api/v1/departments
PATCH  /api/v1/departments/:id
DELETE /api/v1/departments/:id
```

### Employees

```text
GET    /api/v1/employees
GET    /api/v1/employees/:id
POST   /api/v1/employees
PATCH  /api/v1/employees/:id
DELETE /api/v1/employees/:id
```

## Example: Create Department

```bash
curl -X POST http://localhost:3000/api/v1/departments \
  -H 'Content-Type: application/json' \
  --data-raw '{"department":{"name":"Engineering"}}'
```

## Example: Create Employee

```bash
curl -X POST http://localhost:3000/api/v1/employees \
  -H 'Content-Type: application/json' \
  --data-raw '{"employee":{"name":"Alice","email":"alice@example.com","salary":70000,"department_id":1}}'
```

When an employee is created, an `EmployeeWelcomeJob` is enqueued through Active Job and processed asynchronously by Sidekiq using Redis.

The current job simulates a welcome email by writing a log message. No external email provider is configured.

## Architecture

```text
                    Client
                      |
                      v
              Rails REST API
                      |
          +-----------+-----------+
          |                       |
          v                       v
     PostgreSQL                 Redis
                                  |
                               Sidekiq
                                  |
                        EmployeeWelcomeJob
```

### Main Components

**Rails API**

Handles HTTP requests, validation, CRUD operations, and JSON responses.

**PostgreSQL**

Stores employees and departments.

**Redis**

Used as the backend for Sidekiq job processing.

**Sidekiq**

Processes background jobs asynchronously.

**Active Job**

Provides the Rails interface for enqueueing background jobs.

**RSpec**

Provides automated tests for models and background job processing.

## Database Relationship

```text
Department
    |
    | has_many
    v
Employee
    |
    | belongs_to
    v
Department
```

Each employee belongs to one department, while a department can have multiple employees.

## Validations

### Department

* Name is required
* Name must be unique

### Employee

* Name is required
* Email is required
* Email must be unique
* Salary must be greater than or equal to zero
* Employee must belong to a department

## Background Job Processing

When an employee is created:

```text
API Request
    |
    v
Employee saved
    |
    v
EmployeeWelcomeJob.perform_later
    |
    v
Redis
    |
    v
Sidekiq
    |
    v
EmployeeWelcomeJob
```

The job currently logs a simulated welcome email notification.

## Testing

Run the test suite with:

```bash
bundle exec rspec
```

The project includes tests for:

* Department validations
* Employee validations
* EmployeeWelcomeJob processing

## Running Locally

### 1. Start PostgreSQL

```bash
docker run --name employee-postgres \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=employee_management_api_development \
  -p 5432:5432 \
  -d postgres:16
```

### 2. Start Redis

```bash
docker run --name employee-redis \
  -p 6379:6379 \
  -d redis:7
```

### 3. Setup the database

```bash
rails db:create
rails db:migrate
```

### 4. Start Rails

```bash
rails server
```

### 5. Start Sidekiq

In another terminal:

```bash
bundle exec sidekiq
```

The API will be available at:

```text
http://localhost:3000
```

## Project Structure

```text
app/
├── controllers/
│   └── api/
│       └── v1/
│           ├── departments_controller.rb
│           └── employees_controller.rb
│
├── jobs/
│   └── employee_welcome_job.rb
│
└── models/
    ├── department.rb
    └── employee.rb

spec/
├── jobs/
│   └── employee_welcome_job_spec.rb
│
└── models/
    ├── department_spec.rb
    └── employee_spec.rb
```

## Design Decisions

### API Versioning

The API uses `/api/v1` so future API versions can be introduced without breaking existing clients.

### Background Processing

Welcome notifications are processed asynchronously using Sidekiq so background work does not block the API request.

### Strong Parameters

Only permitted employee and department attributes can be written through the API.

### Database Relationships

Employees belong to departments, and departments can have multiple employees.

## Future Improvements

Possible production enhancements include:

* JWT or OAuth-based authentication
* Authorization and role-based access control
* Pagination and filtering
* API request rate limiting
* Real email provider integration
* Structured logging and monitoring
* CI/CD pipeline
* API documentation using OpenAPI/Swagger
