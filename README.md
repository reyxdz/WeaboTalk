# 🎌 WeaboTalk - Social Media for Anime Lovers

**Logo**: WT  
**Description**: A social media platform designed for anime enthusiasts to connect, share content, and engage with real-time notifications.

![Ruby Version](https://img.shields.io/badge/Ruby-4.0.0-red?logo=ruby)
![Rails Version](https://img.shields.io/badge/Rails-8.1.2-red?logo=rails)
![Code Style](https://img.shields.io/badge/code%20style-rubocop-333?logo=ruby)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📋 Overview

WeaboTalk is an MVP (Minimum Viable Product) social platform built with **Ruby on Rails** and **PostgreSQL**, featuring real-time notifications via **Action Cable** and modern frontend interactions with **Hotwire Stimulus**.

### Core Features (MVP)

✅ **User Authentication** - Sign up, login, password recovery  
✅ **User Profiles** - Avatar, banner, bio  
✅ **Post Creation** - Text posts with images  
✅ **Engagement** - Like, react with emojis, comment  
✅ **Real-time Notifications** - Comment, like, reaction, friend request alerts  
✅ **Friend System** - Add/remove friends, friend requests  
✅ **User Search** - Find other anime lovers  

---

## 🛠️ Tech Stack

### Backend
- **Framework**: Ruby on Rails 8.1
- **Database**: PostgreSQL 13+
- **Authentication**: Devise gem
- **Authorization**: Pundit gem
- **Real-time**: Action Cable with WebSocket

### Frontend
- **JavaScript Framework**: Hotwire Stimulus
- **HTTP Protocol**: Turbo (included in Rails)
- **CSS Framework**: Tailwind CSS with Daisy UI components
- **Build Tool**: esbuild/Webpack

### Additional Gems
- **Authentication**: devise
- **Authorization**: pundit (~> 2.3)
- **Pagination**: pagy (~> 7.0)
- **Background Jobs**: sidekiq
- **Image Processing**: image_processing (~> 1.2)
- **Active Storage**: For image uploads

---

## 🚀 Quick Start

### Prerequisites
- Ruby 4.0.0+
- Rails 8.1.2+
- PostgreSQL 13+
- Node.js 18+
- Git
- Bundler

### Installation Steps

```bash
# 1. Clone the repository
git clone <repository-url>
cd weabotalk

# 2. Install Ruby dependencies
bundle install

# 3. Create database
rails db:create

# 4. Run migrations
rails db:migrate

# 5. Setup Devise
rails generate devise:install
rails generate devise User
rails db:migrate

# 6. Install JavaScript dependencies
./bin/dev

# 7. Visit application
open http://localhost:3000
```

For detailed setup instructions, see [SETUP_GUIDE.md](./SETUP_GUIDE.md)

---

## 📁 Project Structure

```
weabotalk/
├── app/
│   ├── models/              # Redux of business logic
│   ├── controllers/         # Request handlers
│   ├── views/              # View templates (ERB)
│   ├── channels/           # Action Cable channels
│   ├── jobs/               # Background jobs
│   ├── policies/           # Pundit authorization
│   └── javascript/controllers/  # Stimulus controllers
├── config/
│   ├── routes.rb           # Routes configuration
│   ├── cable.yml           # Action Cable config
│   └── database.yml        # Database config
├── db/
│   ├── migrate/            # Database migrations
│   └── seeds.rb            # Seed data
├── test/                   # Test suite
├── Gemfile                 # Ruby dependencies
├── PROJECT_MANAGEMENT.md   # Team & sprints
├── SETUP_GUIDE.md         # Development setup
├── DEVELOPER_GUIDE.md     # Quick reference
└── ACTION_CABLE_SETUP.md  # Websocket guide
```

---

## 👥 Team & Responsibilities

| Member | Role | Responsibility | Technologies |
|--------|------|-----------------|---------------|
| **1** | Backend Lead | Authentication, User Profiles | Devise, PostgreSQL, Models |
| **2** | Full-stack | Posts, Media Management | Active Storage, Stimulus, forms |
| **3** | Real-time Lead | Engagement, Notifications | Action Cable, WebSocket, Sidekiq |

### Sprint Planning
See [PROJECT_MANAGEMENT.md](./PROJECT_MANAGEMENT.md) for:
- User stories by member
- Task allocation
- Sprint phases
- Database schema assignments

---

## 🗄️ Database Schema

### Core Tables

**users** (via Devise)
- id, email, encrypted_password, created_at, updated_at

**profiles**
- id, user_id, username, bio, avatar, banner

**posts**
- id, user_id, title, content, created_at, updated_at

**comments**
- id, user_id, post_id, parent_comment_id, content

**likes**
- id, user_id, post_id (unique constraint)

**reactions**
- id, user_id, post_id, reaction_type (emoji)

**friendships**
- id, user_id, friend_id, status (pending/accepted)

**notifications** (polymorphic)
- id, user_id, notifiable_type, notifiable_id, notification_type, read_at

See [db/MIGRATION_GUIDE.md](./db/MIGRATION_GUIDE.md) for migration templates.

---

## 🔌 Key Features Implementation

### Real-time Notifications (Action Cable)
See [ACTION_CABLE_SETUP.md](./ACTION_CABLE_SETUP.md)

WebSocket connections enable live notifications for:
- Comment on your post
- Like/react to your post
- Friend request received

### Post Creation with Stimulus
See templates in: `app/javascript/controllers/`

Features:
- Real-time form validation
- Drag-and-drop image upload
- Image preview
- Character counter
- Stimulus-powered interactions

### Engagement System
Features:
- Like toggle
- Emoji reactions (😍, 😂, 😢, 😡, 👍, 🔥, 💯, ❤️, 🎉)
- Comment threads
- Real-time updates

---

## 🧪 Testing

```bash
# Run all tests
rails test

# Run specific test
rails test test/models/user_test.rb

# With coverage report
bundle exec simplecov
```

Test files are in:
- `test/models/`
- `test/controllers/`
- `test/integration/`

---

## 🔒 Security Features

✅ Devise for secure authentication  
✅ Pundit for authorization  
✅ CSRF protection on all forms  
✅ Strong parameters validation  
✅ Secure password storage (bcrypt)  
✅ Encrypted database credentials  

---

## 📱 API Endpoints

### Authentication (Member 1)
```
POST   /users/sign_up
POST   /users/sign_in
DELETE /users/sign_out
GET    /profiles/:id
PATCH  /profiles/:id
```

### Posts (Member 2)
```
GET    /posts
POST   /posts
GET    /posts/:id
PATCH  /posts/:id
DELETE /posts/:id
```

### Engagement (Member 3)
```
POST   /posts/:id/likes
DELETE /posts/:id/likes
POST   /posts/:id/reactions
POST   /posts/:id/comments
GET    /users/search
POST   /friendships
DELETE /friendships/:id
GET    /notifications
PATCH  /notifications/:id/read
```

---

## 🚀 Development Workflow

### Feature Branch Workflow
```bash
# 1. Create feature branch
git checkout -b feature/US-X.X-description

# 2. Make changes and commit
git add .
git commit -m "[US-X.X] Description"

# 3. Push to remote
git push origin feature/US-X.X-description

# 4. Create Pull Request on GitHub

# 5. After code review, merge to main
```

### How to Run Locally

```bash
# Terminal 1: Start Rails server
./bin/dev

# Terminal 2: Access the app
open http://localhost:3000
```

---

## 📖 Documentation

| Document | Purpose |
|----------|---------|
| [SETUP_GUIDE.md](./SETUP_GUIDE.md) | Environment setup, troubleshooting |
| [PROJECT_MANAGEMENT.md](./PROJECT_MANAGEMENT.md) | Sprint planning, task allocation |
| [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md) | Quick reference for all developers |
| [ACTION_CABLE_SETUP.md](./ACTION_CABLE_SETUP.md) | Real-time feature implementation |
| [db/MIGRATION_GUIDE.md](./db/MIGRATION_GUIDE.md) | Database migration templates |

---

## 🔧 Environment Setup

### Development
```bash
# Auto-runs Rails, Webpack, and asset pipeline
./bin/dev
```

### Production Deployment Checklist
- [ ] PostgreSQL database configured
- [ ] Redis instance running (for Action Cable)
- [ ] Environment variables set (.env)
- [ ] SSL certificates installed
- [ ] Sidekiq job processor deployed
- [ ] Error tracking (Sentry) configured
- [ ] All tests passing
- [ ] Security audit completed

---

## 📊 Performance Optimization

- Implement database indexing
- Use pagination (Pagy gem)
- Cache frequently accessed data
- Optimize images with Active Storage
- Monitor with `view logs` in development
- Profile with New Relic in production

---

## 🐛 Troubleshooting

### Common Issues

**Port 3000 in use?**
```bash
lsof -i :3000 && kill -9 <PID>
```

**Bundle install failing?**
```bash
bundle install --force
bundle update
```

**Database errors?**
```bash
rails db:drop db:create db:migrate
```

**JavaScript not compiling?**
```bash
./bin/javascript-bundle-build
```

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for more troubleshooting.

---

## 📝 Contributing

1. Create a feature branch: `git checkout -b feature/US-X.X-description`
2. Make your changes
3. Write/update tests
4. Commit: `git commit -m "[US-X.X] Description"`
5. Push: `git push origin feature/US-X.X-description`
6. Create Pull Request with code review

### Code Standards
- Follow Rails conventions
- Use rubocop for linting: `bundle exec rubocop`
- Write tests for new features
- Document complex logic

---

## 🚢 Deployment

### Production Deployment
```bash
# Build production assets
rails assets:precompile

# Run migrations on production
rails db:migrate RAILS_ENV=production

# Start Puma server with Kamal
kamal deploy
```

---

## 📚 Resources

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Action Cable API](https://guides.rubyonrails.org/action_cable_overview.html)
- [Devise Documentation](https://github.com/heartcombo/devise)
- [Stimulus Handbook](https://stimulus.hotwired.dev/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Pundit Authorization](https://github.com/varvet/pundit)

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## 👨‍💻 Authors

**WeaboTalk Team**
- Member 1: Backend/Authentication
- Member 2: Frontend/Posts
- Member 3: Real-time/Notifications

---

## 🙏 Acknowledgments

Built with ❤️ for anime lovers using Ruby on Rails, Action Cable, and Hotwire Stimulus.

---

**Last Updated**: February 18, 2026  
**Version**: 1.0.0 (MVP)  
**Status**: 🚧 In Development
#   W e a b o T a l k 
 
 