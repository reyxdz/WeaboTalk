# WeaboTalk - Development Setup Guide

## Prerequisites

Ensure you have the following installed:
- Ruby 4.0.0 or higher
- Rails 8.1.2 or higher
- PostgreSQL 13+ (with psql commandline tools)
- Node.js 18+ (for Webpack)
- Git
- Bundler

---

## Windows-Specific Setup (IMPORTANT)

### 1. Install PostgreSQL

Download and install from [postgresql.org](https://www.postgresql.org/download/windows/)
- Remember your password for the postgres user
- Add PostgreSQL to PATH during installation

### 2. Ruby & DevKit

Install Ruby from [rubyinstaller.org](https://rubyinstaller.org/)
- Download Ruby 4.0.0 (x64 with DevKit)
- Run the installer and ensure DevKit is installed

### 3. Git

Install from [git-scm.com](https://git-scm.com/download/win)

### 4. Node.js

Install from [nodejs.org](https://nodejs.org/)

---

## Initial Setup Steps

### 1. Navigate to Project Directory
```bash
cd "c:\Personal Projects\WeaboTalk"
```

### 2. Install Dependencies
```bash
bundle install
```

If you encounter psych gem issues:
```bash
bundle install --ignore-warnings
```

### 3. Create Database
```bash
rails db:create
```

### 4. Run Database Migrations
```bash
rails db:migrate
```

### 5. Setup Devise
```bash
rails generate devise:install
```
Then
```bash
rails generate devise User
rails db:migrate
```

### 6. Setup Pundit
```bash
rails generate pundit:install
```

### 7. Install JavaScript Dependencies
```bash
bundle exec rails javascript:install:esbuild
```

### 8. Setup Hotwire Stimulus
```bash
rails generate stimulus
```

### 9. Seed Database (Optional)
```bash
rails db:seed
```

### 10. Start Development Server
```bash
./bin/dev
```

Server will run at: `http://localhost:3000`

---

## Application Structure

```
WeaboTalk/
├── app/
│   ├── models/              # AR Models (User, Post, Comment, etc.)
│   ├── controllers/         # Request handlers
│   ├── views/              # View templates
│   ├── jobs/               # Background jobs (ActionJob)
│   ├── channels/           # Action Cable channels (WebSocket)
│   ├── policies/           # Pundit authorization policies
│   └── helpers/            # View helpers
├── config/
│   ├── routes.rb           # Route definitions
│   ├── cable.yml           # Action Cable configuration
│   └── database.yml        # Database configuration
├── db/
│   ├── migrate/            # Database migrations
│   └── seeds.rb            # Seed data
├── test/                   # Test suite
├── app/JavaScript/         # Stimulus controllers
├── Gemfile                 # Ruby dependencies
├── PROJECT_MANAGEMENT.md   # Team & task planning
└── SETUP_GUIDE.md         # This file
```

---

## Database Schema Overview

### Core Tables

**users** (Devise handles this)
- id, email, encrypted_password, created_at, updated_at

**profiles**
- id, user_id, avatar, banner, bio, username, created_at, updated_at

**posts**
- id, user_id, title, content, created_at, updated_at

**post_images**
- id, post_id, image (Active Storage blob)

**comments**
- id, user_id, post_id, parent_comment_id, content, created_at, updated_at

**likes**
- id, user_id, post_id, created_at, updated_at

**reactions**
- id, user_id, post_id, reaction_type (string: emoji), created_at, updated_at

**friendships**
- id, user_id, friend_id, status (string: pending/accepted), created_at, updated_at

**notifications**
- id, user_id, notifiable_type, notifiable_id, notification_type, read_at, created_at

---

## Key Gems Installed

| Gem | Purpose |
|-----|---------|
| rails | Web framework |
| pg | PostgreSQL adapter |
| devise | User authentication |
| pundit | Authorization |
| pagy | Pagination |
| stimulus-rails | JavaScript framework |
| turbo-rails | HTTP over HTML |
| action cable | WebSocket support |
| sidekiq | Background jobs |
| image_processing | Image processing |

---

## Development Workflow

### Member 1: Authentication & User Management
1. Create models in `app/models/`
2. Generate migrations: `rails g migration <name>`
3. Update user model with associations
4. Create Pundit policies in `app/policies/`

### Member 2: Posts & Media
1. Generate Post model: `rails g model Post user:references title:string content:text`
2. Setup Active Storage: `rails active_storage:install`
3. Create Stimulus controllers in `app/javascript/controllers/`
4. Add image upload handling

### Member 3: Social Features & Notifications
1. Generate models (Like, Comment, Reaction, Friendship, Notification)
2. Setup Action Cable channels in `app/channels/`
3. Create background jobs in `app/jobs/`
4. Setup WebSocket broadcasting

---

## Git Workflow

### Create Feature Branch
```bash
git checkout -b feature/US-X.X-description
```

### Commit Changes
```bash
git add .
git commit -m "[US-X.X] Brief description

- Detailed change 1
- Detailed change 2"
```

### Push to Remote
```bash
git push origin feature/US-X.X-description
```

### Create Pull Request
Use GitHub Desktop or Web UI to create PR for code review

---

## Testing

### Run All Tests
```bash
rails test
```

### Run Specific Test File
```bash
rails test test/models/user_test.rb
```

### Run with Coverage
```bash
bundle exec simplecov
```

---

## Database Management

### Create Database
```bash
rails db:create
```

### Run Migrations
```bash
rails db:migrate
```

### Rollback Last Migration
```bash
rails db:rollback
```

### Seed Database
```bash
rails db:seed
```

### Reset Database (dev only!)
```bash
rails db:drop db:create db:migrate db:seed
```

---

## Troubleshooting

### Port 3000 Already in Use
```bash
lsof -i :3000  # Find process
kill -9 <PID>  # Kill process
# Or use different port:
rails s -p 3001
```

### Bundler Issues
```bash
bundle install --force
```

### Database Connection Issues
- Check PostgreSQL is running
- Verify database.yml credentials
- Test connection: `rails db:migrate`

### JavaScript Compilation Errors
```bash
./bin/javascript-bundle-build
```

### Action Cable Issues
- Ensure Redis is running for production
- Check cable.yml configuration
- Verify WebSocket URL in development.rb

---

## Production Deployment Checklist

- [ ] Environment variables configured
- [ ] Database backups enabled
- [ ] Action Cable configured for production
- [ ] SSL certificates installed
- [ ] CDN configured for static assets
- [ ] Background job processor (Sidekiq) deployed
- [ ] Redis instance running
- [ ] Error tracking (Sentry) configured
- [ ] Logging configured
- [ ] All tests passing

---

## Useful Rails Commands

```bash
# Generate new resource
rails g resource Post title:string content:text user:references

# Create migration
rails g migration AddStatusToPosts status:string

# Rollback migrations
rails db:rollback STEP=5

# Best practices check
bundle exec rubocop

# Security audit
bundle exec brakeman

# Open Rails console
rails console

# Create seed data
rails db:seed
```

---

## Documentation Links

- [Rails Guides](https://guides.rubyonrails.org/)
- [Action Cable API](https://guides.rubyonrails.org/action_cable_overview.html)
- [Devise Documentation](https://github.com/heartcombo/devise)
- [Pundit Authorization](https://github.com/varvet/pundit)
- [Stimulus Handbook](https://stimulus.hotwired.dev/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Last Updated**: February 18, 2026
