# WeaboTalk - Developer Quick Reference Guide

**Project**: Social media platform for anime lovers  
**Tech Stack**: Ruby on Rails 8.1, PostgreSQL, Action Cable, Devise, Hotwire Stimulus  
**Team**: 3 members

---

## 📋 Quick Navigation

| Member | Responsibility | Key Files | Tech Focus |
|--------|-----------------|-----------|-----------|
| **Member 1** | Authentication & User Management | `User`, `Profile` models | Devise, PostgreSQL |
| **Member 2** | Posts & Media | `Post`, `PostImage` models | Active Storage, Stimulus |
| **Member 3** | Social Features & Notifications | `Comment`, `Like`, `Reaction`, `Friendship`, `Notification` | Action Cable, WebSocket |

---

## 🚀 Getting Started (All Members)

### 1. Clone Repository
```bash
git clone <repository-url>
cd weabotalk
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Create Database
```bash
rails db:create
rails db:migrate
```

### 4. Setup Devise
```bash
rails generate devise:install
rails generate devise User
rails db:migrate
```

### 5. Start Development Server
```bash
./bin/dev
```

Access: `http://localhost:3000`

---

## 👤 MEMBER 1: Authentication & User Management

### User Stories to Complete

| US | Title | Points | Status |
|----|-------|--------|--------|
| US-1.1 | Device Authentication - Sign Up | 2 | ⬜ Not Started |
| US-1.2 | Device Authentication - Login/Logout | 1 | ⬜ Not Started |
| US-1.3 | Password Recovery | 1 | ⬜ Not Started |
| US-1.4 | User Profile Management | 3 | ⬜ Not Started |

### Key Files to Create/Update

```
app/models/
  ├── user.rb (with Devise setup)
  └── profile.rb

app/controllers/
  ├── users_controller.rb
  ├── profiles_controller.rb
  └── devise customizations

app/policies/
  ├── user_policy.rb
  └── profile_policy.rb

app/views/
  ├── user auth views
  └── profile views
```

### Database Migrations
```bash
# Devise automatically generates User table
# You need to create:
rails generate migration CreateProfiles
```

### First Steps
1. Run Devise install and User generation
2. Customize User model with associations
3. Create Profile model with image attachments
4. Build User registration and profile setup flow
5. Add authorization policies (Pundit)

### Test Checklist
- [ ] User can sign up with email
- [ ] Email validation works
- [ ] User can log in
- [ ] Session persists
- [ ] Password reset works
- [ ] User can edit profile
- [ ] Profile avatar uploads work

---

## 📸 MEMBER 2: Posts & Media Management

### User Stories to Complete

| US | Title | Points | Status |
|----|-------|--------|--------|
| US-2.1 | Create Text Post | 2 | ⬜ Not Started |
| US-2.2 | Image Upload & Post | 3 | ⬜ Not Started |
| US-2.3 | Edit & Delete Posts | 2 | ⬜ Not Started |
| US-2.4 | Post Feed & Pagination | 2 | ⬜ Not Started |

### Key Files to Create/Update

```
app/models/
  ├── post.rb
  └── post_image.rb

app/controllers/
  └── posts_controller.rb

app/policies/
  └── post_policy.rb

app/views/posts/
  ├── new.html.erb
  ├── edit.html.erb
  ├── show.html.erb
  └── index.html.erb

app/javascript/controllers/
  └── post_form_controller.js (with validation & image upload)
```

### Tech Stack for Member 2
- **Backend**: Rails models & controllers
- **Frontend**: Hotwire Stimulus + **Daisy UI Components**
- **Styling**: Tailwind CSS with Daisy UI
- **Form Validation**: Stimulus controller
- **Image Upload**: Active Storage + Daisy UI file input

### Key Features to Implement
1. Post creation form with title and content using Daisy UI form components
2. Drag-and-drop image upload with Daisy UI input styling
3. Image validation (size, format) with error alerts
4. Real-time form validation with Stimulus
5. Edit and delete functionality with Daisy UI modals
6. Post feed with pagination (Pagy gem)
7. Beautiful card layout using Daisy UI `card` component

### Daisy UI Components You'll Use
- `input` - Text input for titles
- `textarea` - Content textarea
- `file-input` - Image upload
- `card` - Post display cards
- `btn` - Action buttons
- `badge` - Like/reaction counts
- `modal` - Edit/delete confirmations
- `avatar` - User profile pictures in posts

### Test Checklist
- [ ] User can create post with title and content
- [ ] User can upload multiple images
- [ ] Images are previewed before posting
- [ ] User can edit their own posts
- [ ] User can delete their own posts
- [ ] Post feed displays recent posts
- [ ] Pagination works correctly

---

## 💬 MEMBER 3: Social Features & Real-time Notifications

### User Stories to Complete

| US | Title | Points | Status |
|----|-------|--------|--------|
| US-3.1 | Like & React to Posts | 2 | ⬜ Not Started |
| US-3.2 | Comments & Discussion | 3 | ⬜ Not Started |
| US-3.3 | Real-time Notifications via Action Cable | 4 | ⬜ Not Started |
| US-3.4 | Friend System | 3 | ⬜ Not Started |
| US-3.5 | User Search | 2 | ⬜ Not Started |
| US-3.6 | Notification - Comments | 1 | ⬜ Not Started |
| US-3.7 | Notification - Likes & Reactions | 1 | ⬜ Not Started |
| US-3.8 | Notification - Friend Requests | 1 | ⬜ Not Started |

### Key Files to Create/Update

```
app/models/
  ├── comment.rb
  ├── like.rb
  ├── reaction.rb
  ├── friendship.rb
  └── notification.rb

app/controllers/
  ├── comments_controller.rb
  ├── likes_controller.rb
  ├── reactions_controller.rb
  ├── friendships_controller.rb
  ├── notifications_controller.rb
  └── users_controller.rb (search)

app/channels/
  ├── application_cable/
  │   ├── channel.rb
  │   └── connection.rb
  └── notifications_channel.rb

app/jobs/
  └── notification_broadcast_job.rb

app/javascript/controllers/
  ├── notification_controller.js
  └── post_engagement_controller.js
```

### Database Setup
```bash
# Create models
rails generate model Comment user:references post:references parent_comment:references content:text
rails generate model Like user:references post:references
rails generate model Reaction user:references post:references reaction_type:string
rails generate model Friendship user:references friend:references status:string
rails generate model Notification user:references notifiable:polymorphic notification_type:string read_at:datetime

rails db:migrate
```

### Key Features to Implement

#### Engagement (Like & React)
- Like button with toggle
- Emoji reaction picker
- Real-time like/reaction count
- Reaction aggregation

#### Comments
- Comment form with validation
- Nested comment threads (replies)
- Real-time comment loading
- Delete own comments

#### Notifications (Action Cable)
- WebSocket connection setup
- Notification broadcasting
- Real-time notification display
- Mark as read functionality
- Notification bell with count

#### Friend System
- Send/accept friend requests
- Unfriend functionality
- Friend list view
- Friend status display

#### Search
- Search users by username
- Search results display
- Real-time search (Stimulus)

### Test Checklist
- [ ] User can like posts
- [ ] User can add emoji reactions
- [ ] Like/reaction counts update in real-time
- [ ] User can comment on posts
- [ ] Comments appear in real-time
- [ ] User can reply to comments
- [ ] Notifications appear in real-time
- [ ] Notification bell shows unread count
- [ ] User can send friend requests
- [ ] User can accept/reject friend requests
- [ ] User search works

---

## 🔄 Git Workflow for All Members

### Create Feature Branch
```bash
git checkout -b feature/US-X.X-description
```

### Make Changes
```bash
git add .
git commit -m "[US-X.X] Brief description

- Change 1
- Change 2"
```

### Push to Remote
```bash
git push origin feature/US-X.X-description
```

### Create Pull Request
- Use GitHub/GitLab interface
- Link to User Story
- Request code review from other member

### Code Review Checklist
- [ ] Code follows Rails conventions
- [ ] Tests are included
- [ ] No console logs or debug code
- [ ] Database migrations are reversible
- [ ] Feature documented

---

## 📚 Resource Files

| File | Purpose | Audience |
|------|---------|----------|
| `PROJECT_MANAGEMENT.md` | Sprint planning & task allocation | All |
| `SETUP_GUIDE.md` | Development environment setup | All |
| `DEVELOPER_GUIDE.md` | This file - quick reference | All |
| `ACTION_CABLE_SETUP.md` | Real-time setup guide | Member 3 |
| `db/MIGRATION_GUIDE.md` | Database migration templates | All |

---

## 🧪 Testing

### Run All Tests
```bash
rails test
```

### Run Specific Test File
```bash
rails test test/models/post_test.rb
```

### Test Models
```ruby
# test/models/user_test.rb
class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  def test_user_is_valid
    assert @user.valid?
  end
end
```

---

## 🐛 Common Issues & Solutions

### Port 3000 Already in Use
```bash
# Find and kill process
lsof -i :3000
kill -9 <PID>
```

### Database Connection Error
```bash
# Verify PostgreSQL is running
psql -U postgres
# Recreate database
rails db:drop db:create db:migrate
```

### Gems Not Installing
```bash
# Force update
bundle install --force
bundle update
```

### JavaScript Not Compiling
```bash
./bin/javascript-bundle-build
```

---

## 📱 API Endpoints (By Member)

### Member 1 Endpoints
```
POST   /users/sign_up
POST   /users/sign_in
DELETE /users/sign_out
GET    /profiles/:id
PATCH  /profiles/:id
```

### Member 2 Endpoints
```
GET    /posts
POST   /posts
GET    /posts/:id
PATCH  /posts/:id
DELETE /posts/:id
```

### Member 3 Endpoints
```
POST   /posts/:id/likes
DELETE /posts/:id/likes
POST   /posts/:id/reactions
POST   /posts/:id/comments
GET    /comments/:id/replies
POST   /friendships
PATCH  /friendships/:id
DELETE /friendships/:id
GET    /users/search
GET    /notifications
PATCH  /notifications/:id/read
```

---

## 🎯 Performance Tips

- Use database indexes for frequently queried fields
- Implement pagination for large datasets (use Pagy)
- Cache static assets
- Use Active Storage for image optimization
- Monitor database queries in development logs
- Use background jobs for heavy operations (Sidekiq)

---

## 🔒 Security Checklist

- [ ] Use strong_parameters in all controllers
- [ ] Implement authorization with Pundit
- [ ] Validate all user input
- [ ] Use parameterized queries
- [ ] Hash passwords (Devise does this)
- [ ] Implement CSRF protection
- [ ] Use secure cookies
- [ ] Rate limit API endpoints
- [ ] Log security events

---

## 📞 Communication

- Use GitHub Issues for bugs
- Use Pull Request comments for code review
- Daily standup if needed
- Update PROJECT_MANAGEMENT.md status daily

---

**Last Updated**: February 18, 2026  
**Questions?** Check SETUP_GUIDE.md and ACTION_CABLE_SETUP.md
