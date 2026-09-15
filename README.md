# Employee Management API

A production-style REST API built with Ruby on Rails 8 for managing employees and departments.

## Tech Stack

- Ruby 3.4
- Ruby on Rails 8
- PostgreSQL
- REST API
- Docker
- Redis / Sidekiq
- RSpec
- RuboCop

## Features

- Employee CRUD operations
- Department management
- Employee-department relationship
- Request validation
- Unique email validation
- API versioning
- Error handling
- Background job processing
- Automated testing
- Docker-based development

## API Endpoints

### Employees

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/employees` | List employees |
| GET | `/api/v1/employees/:id` | Get employee |
| POST | `/api/v1/employees` | Create employee |
| PATCH | `/api/v1/employees/:id` | Update employee |
| DELETE | `/api/v1/employees/:id` | Delete employee |

### Departments

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/departments` | List departments |
| GET | `/api/v1/departments/:id` | Get department |
| POST | `/api/v1/departments` | Create department |
| PATCH | `/api/v1/departments/:id` | Update department |
| DELETE | `/api/v1/departments/:id` | Delete department |

## Architecture

Client → Rails API → PostgreSQL

Background processing:

Rails API → Redis → Sidekiq Worker

## Design Decisions

- API versioning allows future API changes without breaking existing clients.
- ActiveRecord associations maintain the employee-department relationship.
- Model validations protect data integrity.
- Background jobs are used for asynchronous processing.
- PostgreSQL is used as the primary relational database.

## Running the Application

```bash
bundle install
rails db:create
rails db:migrate
rails server