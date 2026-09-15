# Employee Management API — Architecture & Design

## 1. Overview

Employee Management API is a versioned REST API built with Ruby on Rails.

The application provides CRUD operations for employees and departments and demonstrates asynchronous background processing using Active Job, Sidekiq, and Redis.

## 2. Technology Stack

* Ruby 3.4
* Ruby on Rails 8
* PostgreSQL
* Redis
* Sidekiq
* Active Job
* RSpec
* Docker
* REST API

## 3. High-Level Architecture

```text
                    API Client
                        |
                        v
                 +-------------+
                 |  Rails 8 API|
                 +-------------+
                   |         |
                   |         |
                   v         v
            +----------+  +-------+
            |PostgreSQL|  | Redis |
            +----------+  +-------+
                              |
                              v
                         +---------+
                         | Sidekiq |
                         +---------+
                              |
                              v
                    +-------------------+
                    | EmployeeWelcomeJob|
                    +-------------------+
```

## 4. Component Responsibilities

### Rails API

The Rails API is responsible for:

* Receiving HTTP requests
* Validating request parameters
* Performing CRUD operations
* Applying Strong Parameters
* Returning JSON responses
* Enqueuing background jobs

### PostgreSQL

PostgreSQL is used for persistent relational data.

The main entities are:

* Department
* Employee

### Redis

Redis is used by Sidekiq for background job queue processing.

### Sidekiq

Sidekiq processes background jobs asynchronously.

This keeps background work separate from the main API request.

### Active Job

Rails Active Job provides the interface used to enqueue the background job.

Example:

```ruby
EmployeeWelcomeJob.perform_later(employee.id)
```

### RSpec

RSpec is used for automated testing.

The project includes tests for:

* Department validations
* Employee validations
* EmployeeWelcomeJob processing

## 5. API Versioning

The API uses the following structure:

```text
/api/v1
```

Example:

```text
GET /api/v1/employees
```

Versioning allows future API versions to be introduced without immediately breaking existing clients.

## 6. API Endpoints

### Employees

```text
GET    /api/v1/employees
GET    /api/v1/employees/:id
POST   /api/v1/employees
PATCH  /api/v1/employees/:id
DELETE /api/v1/employees/:id
```

### Departments

```text
GET    /api/v1/departments
GET    /api/v1/departments/:id
POST   /api/v1/departments
PATCH  /api/v1/departments/:id
DELETE /api/v1/departments/:id
```

## 7. Data Model

The relationship is:

```text
Department
    |
    | has_many
    |
    v
Employee
    |
    | belongs_to
    |
    v
Department
```

### Department

* `id`
* `name`
* `created_at`
* `updated_at`

### Employee

* `id`
* `name`
* `email`
* `salary`
* `department_id`
* `created_at`
* `updated_at`

An employee belongs to one department.

A department can have multiple employees.

## 8. Validation

### Department

* Name is required
* Name must be unique

### Employee

* Name is required
* Email is required
* Email must be unique
* Salary must be greater than or equal to zero
* Employee must belong to a department

## 9. Employee Creation Flow

When a new employee is created:

```text
Client
   |
   v
POST /api/v1/employees
   |
   v
EmployeesController
   |
   v
Employee saved in PostgreSQL
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
EmployeeWelcomeJob executed
```

The current background job simulates a welcome email by writing a log message.

No external email provider is currently configured.

## 10. Why Background Processing?

Background processing is useful when work does not need to block the API response.

For example:

* Sending emails
* Generating reports
* Processing files
* Sending notifications
* Calling external services

In this project, the welcome notification is handled asynchronously.

The API can return the employee response without waiting for the background task to finish.

## 11. Error Handling

For validation failures, the API returns an error response containing validation messages.

Example:

```json
{
  "errors": [
    "Email can't be blank"
  ]
}
```

The API uses appropriate HTTP status codes such as:

```text
201 Created
200 OK
204 No Content
422 Unprocessable Entity
```

## 12. Security Considerations

The current implementation uses:

* Strong Parameters
* Model validations
* API versioning
* Database relationships

Authentication and authorization are not currently implemented.

Possible future improvements include:

* JWT authentication
* OAuth/OIDC
* Role-based authorization
* Rate limiting
* Audit logging

## 13. Testing

Tests are written using RSpec.

Run the test suite:

```bash
bundle exec rspec
```

The test suite covers:

* Department model validation
* Employee model validation
* EmployeeWelcomeJob processing

## 14. Future Improvements

Possible production enhancements include:

* Authentication and authorization
* Pagination
* Filtering and searching
* API documentation using OpenAPI/Swagger
* Real email provider integration
* Monitoring and alerting
* Rate limiting
* CI/CD automation
* Centralized structured logging

## 15. Design Summary

The application follows a simple and maintainable architecture:

```text
Client
  |
  v
Rails API
  |
  +-------> PostgreSQL
  |
  +-------> Redis ---> Sidekiq ---> Background Job
```

The design keeps the API layer responsible for request handling and business operations while moving asynchronous work to background processing.

This provides a clean foundation that can be extended with authentication, authorization, monitoring, and additional services as the application grows.
