# 🎌 WeaboTalk - Social Media for Anime Lovers

**Logo**: WT  
**Description**: A social media platform designed for anime enthusiasts to connect, share content, and engage with real-time notifications.

![Ruby Version](https://img.shields.io/badge/Ruby-4.0.0-red?logo=ruby)
![Rails Version](https://img.shields.io/badge/Rails-8.1.2-red?logo=rails)
![Code Style](https://img.shields.io/badge/code%20style-rubocop-333?logo=ruby)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📋 Overview

WeaboTalk is a full-featured social media platform built with **Ruby on Rails 8.1** and **PostgreSQL**, featuring real-time notifications via **Action Cable** and modern frontend interactions with **Hotwire (Turbo + Stimulus)**.

### ✨ Features

✅ **User Authentication**

- Sign up / Sign in with Devise
- Email confirmation required
- Password recovery
- Secure session management

✅ **User Profiles**

- Custom username
- Avatar and banner images (Active Storage)
- Bio/description
- Followers/following counts

✅ **Post Creation**

- Create posts with title and content
- Multiple image uploads per post
- Edit and delete own posts
- Image preview before posting

✅ **Engagement System**

- **Likes**: Toggle like/unlike on posts
- **Reactions**: 9 emoji reactions (😍, 😂, 😢, 😡, 👍, 🔥, 💯, ❤️, 🎉)
- **Comments**: Threaded/reply support

✅ **Friend System**

- Send friend requests
- Accept/reject requests
- View pending requests
- Remove friends

✅ **Real-time Notifications**

- Live notifications via WebSocket (Action Cable)
- Notifications for: new comments, likes, reactions, friend requests
- Mark as read / Mark all as read

✅ **User Search**

- Find users by username
- Search results page

---

## 🛠️ Tech Stack

### Backend

| Technology       | Purpose              |
| ---------------- | -------------------- |
| **Ruby 4.0.0**   | Programming language |
| **Rails 8.1.2**  | Web framework        |
| **PostgreSQL**   | Primary database     |
| **Devise**       | Authentication       |
| **Pundit**       | Authorization        |
| **Sidekiq**      | Background jobs      |
| **Action Cable** | Real-time WebSocket  |

### Frontend

| Technology           | Purpose                  |
| -------------------- | ------------------------ |
| **Hotwire Turbo**    | SPA-like page navigation |
| **Hotwire Stimulus** | Interactive JavaScript   |
| **Tailwind CSS**     | Utility-first CSS        |
| **Daisy UI**         | UI component library     |
| **esbuild**          | JavaScript bundler       |

### Key Gems

```ruby
gem "devise"                    # Authentication
gem "pundit", "~> 2.3"          # Authorization
gem "pagy", "~> 7.0"            # Pagination
gem "sidekiq"                   # Background jobs
gem "image_processing", "~> 1.2" # Image processing
gem "view_component", "~> 3.0"  # View components
gem "tailwindcss-rails"         # Tailwind integration
gem "turbo-rails"               # Hotwire Turbo
gem "stimulus-rails"            # Hotwire Stimulus
```

---

## 🚀 Quick Start

### Prerequisites

- Ruby 4.0.0+
- Rails 8.1.2+
- PostgreSQL 13+
- Node.js 18+
- Bundler
- Redis (for Action Cable/Sidekiq)

### Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd WeaboTalk

# 2. Install dependencies
bundle install

# 3. Setup database
rails db:create
rails db:migrate

# 4. Install JavaScript dependencies
./bin/dev

# 5. Start the development server
# Visit http://localhost:3000
```

### Running the App

```bash
# Terminal 1: Start Rails + webpack
./bin/dev

# Terminal 2 (optional): Start Sidekiq for background jobs
bundle exec sidekiq

# Visit the app
open http://localhost:3000
```

---

## 📁 Project Structure

```
WeaboTalk/
├── app/
│   ├── channels/              # Action Cable channels
│   │   └── notifications_channel.rb
│   ├── components/            # View Components
│   │   ├── friendships/
│   │   │   └── friend_item_component/
│   │   ├── posts/
│   │   │   └── header_component/
│   │   └── profiles/
│   │       └── image_component/
│   ├── controllers/           # Rails controllers
│   ├── javascript/
│   │   └── controllers/       # Stimulus controllers
│   │       ├── comment_form_controller.js
│   │       ├── friend_button_controller.js
│   │       ├── post_controller.js
│   │       ├── post_form_controller.js
│   │       └── reaction_picker_controller.js
│   ├── models/                # ActiveRecord models
│   └── views/                 # ERB templates
├── config/
│   ├── routes.rb              # Routes definition
│   ├── cable.yml              # Action Cable config
│   └── database.yml           # Database config
├── db/
│   ├── migrate/               # Database migrations
│   └── schema.rb              # Database schema
├── DOCUMENTS/                 # Implementation guides
└── TEMPLATES/                 # Code templates
```

---

## 🗄️ Database Schema

### Core Tables

| Table             | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| **users**         | Devise user accounts (email, password, confirmation)         |
| **profiles**      | User profiles (username, bio, avatar, banner)                |
| **posts**         | User posts (title, content)                                  |
| **post_images**   | Attached images for posts                                    |
| **comments**      | Comments on posts (supports threading via parent_comment_id) |
| **likes**         | Likes on posts (user + post, unique)                         |
| **reactions**     | Emoji reactions (user + post + reaction_type)                |
| **friendships**   | Friend relationships (user, friend, status)                  |
| **notifications** | Real-time notifications (polymorphic)                        |

### Relationships

```
User
├── Profile (1:1)
├── Posts (1:many)
├── PostImages (1:many through Posts)
├── Comments (1:many)
├── Likes (1:many)
├── Reactions (1:many)
├── Friendships (1:many)
└── Notifications (1:many)
```

---

## 🔌 Key Features Implementation

### Real-time Notifications (Action Cable)

**Server-side** (`app/channels/notifications_channel.rb`):

```ruby
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end
end
```

**Features**:

- WebSocket connection for live updates
- Notifications broadcast instantly
- Works alongside Sidekiq for async processing

### Stimulus Controllers

| Controller                   | Purpose                                         |
| ---------------------------- | ----------------------------------------------- |
| `post_form_controller`       | Form validation, image preview, character count |
| `reaction_picker_controller` | Emoji reaction picker UI                        |
| `friend_button_controller`   | AJAX friend request handling                    |
| `comment_form_controller`    | Comment form with validation                    |
| `post_controller`            | Post interactions                               |

### Turbo Streams

Real-time updates using Turbo Stream responses:

- `comments/create.turbo_stream.erb`
- `comments/destroy.turbo_stream.erb`
- `likes/update_likes.turbo_stream.erb`

---

## 📱 API Routes

### Authentication

```
GET    /users/sign_up     # Sign up form
POST   /users/sign_up     # Create account
GET    /users/sign_in     # Sign in form
POST   /users/sign_in     # Authenticate
DELETE /users/sign_out    # Sign out
```

### Profiles

```
GET    /profiles/:username     # View profile
GET    /profiles/:username/edit  # Edit form
PATCH  /profiles/:username    # Update profile
PUT    /profiles/:username    # Update profile
```

### Posts

```
GET    /posts              # List all posts
POST   /posts              # Create post
GET    /posts/:id          # View post
PATCH  /posts/:id          # Update post
DELETE /posts/:id          # Delete post
```

### Engagement

```
POST   /posts/:id/likes              # Like a post
DELETE /posts/:id/likes              # Unlike a post
POST   /posts/:id/reactions          # React to post
DELETE /posts/:id/reactions          # Remove reaction
POST   /posts/:id/comments           # Add comment
DELETE /posts/:id/comments/:id      # Delete comment
```

### Friendships

```
GET    /friendships              # List friendships
POST   /friendships              # Send friend request
DELETE /friendships/:id          # Remove friend/withdraw request
PATCH   /friendships/:id         # Accept/reject request
GET    /friend-requests          # Pending requests
```

### Notifications

```
GET    /notifications                    # All notifications
PATCH  /notifications/:id/mark-as-read  # Mark single as read
PATCH  /notifications/mark-all-as-read  # Mark all as read
DELETE /notifications/:id               # Delete notification
```

### User Search

```
GET    /users/search?q=keyword   # Search users
```

---

## 🎨 UI Components

### Daisy UI Components

- Navbar with user menu
- Cards for posts
- Modals for forms
- Dropdowns for actions
- Forms with validation

### View Components

- `Profile::ImageComponent` - Avatar/banner display
- `Posts::HeaderComponent` - Post header with author info
- `Friendships::FriendItemComponent` - Friend list item

---

## 🧪 Testing

```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/user_test.rb

# Run with coverage
bundle exec simplecov
```

---

## 🔒 Security Features

- ✅ Devise secure authentication
- ✅ Pundit authorization policies
- ✅ CSRF protection on all forms
- ✅ Strong parameters validation
- ✅ bcrypt password hashing
- ✅ Email confirmation required
- ✅ PostgreSQL parameterized queries

---

## 🚧 Development Notes

### Environment Variables

Create a `.env` file for local development:

```bash
DATABASE_URL=postgresql://username:password@localhost/weabotalk_dev
REDIS_URL=redis://localhost:6379/1
```

### Code Style

```bash
# Run Rubocop
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a
```

---

## 📖 Additional Documentation

| Document                                                   | Purpose             |
| ---------------------------------------------------------- | ------------------- |
| [SETUP_GUIDE.md](./SETUP_GUIDE.md)                         | Environment setup   |
| [DEVELOPER_GUIDE.md](./DEVELOPER_GUIDE.md)                 | Quick reference     |
| [ACTION_CABLE_SETUP.md](./DOCUMENTS/ACTION_CABLE_SETUP.md) | WebSocket guide     |
| [PROJECT_MANAGEMENT.md](./PROJECT_MANAGEMENT.md)           | Team & sprints      |
| [db/MIGRATION_GUIDE.md](./db/MIGRATION_GUIDE.md)           | Migration templates |

---

## 🐛 Troubleshooting

### Port 3000 in use

```bash
lsof -i :3000
kill -9 <PID>
```

### Database issues

```bash
rails db:drop db:create db:migrate
```

### JavaScript not loading

```bash
./bin/dev  # Restart the dev server
```

---

## 🚢 Deployment

### Production Checklist

- [ ] PostgreSQL database configured
- [ ] Redis instance running
- [ ] Environment variables set
- [ ] SSL certificates installed
- [ ] Sidekiq deployed
- [ ] Assets precompiled

### Deploy with Kamal

```bash
rails assets:precompile
kamal deploy
```

---

## 📚 Resources

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Hotwire Handbook](https://hotwired.dev/)
- [Stimulus Docs](https://stimulus.hotwired.dev/)
- [Devise Wiki](https://github.com/heartcombo/devise)
- [Pundit Docs](https://github.com/varvet/pundit)
- [Tailwind CSS](https://tailwindcss.com/)
- [Daisy UI](https://daisyui.com/)

---

## 👨‍💻 Authors

**WeaboTalk Team**

---

## 📄 License

MIT License - see LICENSE file for details.

---

## 🙏 Acknowledgments

Built with ❤️ for anime lovers using Ruby on Rails, Action Cable, and Hotwire.

---

**Last Updated**: February 20, 2026  
**Version**: 1.0.0  
**Status**: ✅ Complete
