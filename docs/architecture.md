# System Architecture

The application follows a REST API architecture.

## Flow

Client
↓
Rails API
↓
PostgreSQL

Rails API
↓
Redis
↓
Sidekiq Worker

## Components

### Rails API
Handles HTTP requests, business logic and API responses.

### PostgreSQL
Stores employees, departments and application data.

### Redis
Used for background job queuing.

### Sidekiq
Processes background jobs asynchronously.
