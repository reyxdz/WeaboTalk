# WeaboTalk - MVP Project Management

**Project**: A social media platform for anime lovers
**Logo**: WT
**Start Date**: February 18, 2026
**Tech Stack**: Ruby on Rails, PostgreSQL, Action Cable, Devise, Hotwire Stimulus

---

## Project Overview

WeaboTalk is a social platform designed for anime enthusiasts to connect, share content, and engage with the community through posts, reactions, comments, and friend connections. All interactions feature real-time updates powered by Action Cable WebSockets.

---

## Team Members & Task Allocation

### 👤 **Member 1: Authentication & User Management** (DevOps/Backend Lead)
- **Responsibility**: User authentication, profiles, and session management
- **Tech Focus**: Devise gem, PostgreSQL user schema

### 👤 **Member 2: Post Creation & Media Management** (Frontend/Full-stack)
- **Responsibility**: Post creation, image uploads, edit/delete functionality
- **Tech Focus**: Hotwire Stimulus, Active Storage, form handling

### 👤 **Member 3: Social Interactions & Real-time Notifications** (Real-time/Backend)
- **Responsibility**: Likes, reactions, comments, friend system, real-time notifications
- **Tech Focus**: Action Cable WebSockets, notification system, friend relationships

---

## Sprint Planning: MVP Features

### ✅ **Phase 1: Foundation (Week 1-2)** 
*All Members*
- [✅] Rails project setup and configuration
- [✅] PostgreSQL database setup
- [✅] Devise authentication implementation
- [✅] Git repository initialization
- [✅] Hotwire Stimulus setup and configuration

---

### **Phase 2: User Management (Week 2-3)**

#### Member 1 Tasks:
1. **US-1.1:✅ Device Authentication - Sign Up**
   - [✅] Implement Devise user model
   - [✅] Email validation
   - [✅] Password confirmation
   - [✅] Account activation via email
   - **Estimation**: 2 story points
   - **Priority**: 🔴 Critical

2. **US-1.2: Device Authentication - Login/Logout** ✅
   - [✅] Login functionality
   - [✅] Session management
   - [✅] Remember me option
   - [✅] Logout with session cleanup
   - **Estimation**: 1 story point
   - **Priority**: 🔴 Critical

3. **US-1.3: Password Recovery** ✅
   - [✅] Forgot password flow
   - [✅] Reset password via email link
   - [✅] Token expiration
   - **Estimation**: 1 story point
   - **Priority**: 🟠 High

4. **US-1.4: User Profile Management** ✅
   - [✅] Profile CRUD operations
   - [✅] Avatar/banner upload
   - [✅] Bio and username fields
   - [✅] View other user profiles
   - [✅] Follower/following count display
   - **Estimation**: 3 story points
   - **Priority**: 🟠 High

---

### **Phase 3: Content Creation (Week 3-4)**

Here is your updated checklist with check marks added ✅

---

#### Member 2 Tasks:

### 1. **US-2.1: Create Text Post**

* [✅] Post model with title and content fields
* [✅] Character limit validation
* [x] Draft saving functionality
* [✅] Post preview with Stimulus
* [x] Real-time form validation
* **Estimation**: 2 story points
* **Priority**: 🔴 Critical

---

### 2. **US-2.2: Image Upload & Post**

* [✅] Active Storage integration
* [✅] Multi-image upload
* [✅] Image validation (format, size)
* [x] Drag-and-drop upload with Stimulus
* [✅] Image preview generation
* **Estimation**: 3 story points
* **Priority**: 🔴 Critical

---

### 3. **US-2.3: Edit & Delete Posts**

* [✅] Edit post content
* [✅] Delete with confirmation
* [✅] Authorization (only author can edit/delete)
* [✅] Edit timeline tracking
* [✅] Real-time UI updates with Stimulus
* **Estimation**: 2 story points
* **Priority**: 🟠 High

---

### 4. **US-2.4: Post Feed & Pagination**

* [✅] Display all posts chronologically
* [✅] Pagination implementation
* [✅] Infinite scroll with Stimulus
* [✅] Post detail view
* **Estimation**: 2 story points
* **Priority**: 🟠 High

---

## **Phase 4: Social Features (Week 4-5)**

#### Member 3 Tasks:

### 1. **US-3.1: Like & React to Posts**

* [✅] Like model and associations
* [✅] Reaction types (emoji reactions)
* [✅] Toggle like functionality
* [✅] Real-time like count with Stimulus
* [✅] Like/reaction list view
* **Estimation**: 2 story points
* **Priority**: 🔴 Critical

---

### 2. **US-3.2: Comments & Discussion**

* [✅] Comment model with associations
* [✅] Create/read/delete comments
* [✅] Comment thread display
* [✅] Nested comment replies
* [✅] Real-time comment loading with Stimulus
* **Estimation**: 3 story points
* **Priority**: 🔴 Critical

---

### 3. **US-3.3: Real-time Notifications via Action Cable**

* [✅] Action Cable channel setup
* [✅] Notification model and associations
* [✅] WebSocket connection for notifications
* [✅] Notification bell with unread count
* [✅] Mark as read/dismiss functionality
* [✅] Real-time notification broadcasting
* **Estimation**: 4 story points
* **Priority**: 🔴 Critical

---

### 4. **US-3.4: Friend System**

* [✅] Friendship model with states (pending, accepted)
* [✅] Send friend request
* [✅] Accept/reject requests
* [✅] Unfriend functionality
* [✅] Friend list view
* [] Mutual friends display
* **Estimation**: 3 story points
* **Priority**: 🟠 High

---

### 5. **US-3.5: User Search**

* [✅] Search user by username
* [✅] Search results display
* [✅] Real-time search with Stimulus
* [✅] View user profile from search
* **Estimation**: 2 story points
* **Priority**: 🟠 High
* **Estimation**: 2 story points
* **Priority**: 🟠 High

---



### **Phase 5: Notification Triggers (Week 5-6)**

#### Member 3 Tasks (Dependent on Phase 4):
1. **US-3.6: Notification - Comments**
   - [✅] Trigger notification when someone comments on post
   - [✅] Include post context in notification
   - [✅] Notification link to post
   - **Estimation**: 1 story point
   - **Priority**: 🔴 Critical

2. **US-3.7: Notification - Likes & Reactions**
   - [✅] Trigger notification on post like
   - [✅] Trigger notification on post reaction
   - [✅] Group multiple likes into one notification
   - **Estimation**: 1 story point
   - **Priority**: 🔴 Critical

3. **US-3.8: Notification - Friend Requests**
   - [✅] Trigger notification on friend request
   - [✅] Accept/reject from notification
   - [✅] Show requester info in notification
   - **Estimation**: 1 story point
   - **Priority**: 🔴 Critical

---

## Database Schema Overview

### Member 1 Database Responsibility:
```
tables:
  - users (id, email, encrypted_password, username, created_at, updated_at, encrypted_password_confirmation_token)
  - profiles (id, user_id, avatar, banner, bio, created_at, updated_at)
```

### Member 2 Database Responsibility:
```
tables:
  - posts (id, user_id, title, content, created_at, updated_at)
  - post_images (id, post_id, image_blob_id, created_at, updated_at)
```

### Member 3 Database Responsibility:
```
tables:
  - likes (id, user_id, post_id, created_at, updated_at)
  - reactions (id, user_id, post_id, reaction_type, created_at, updated_at)
  - comments (id, user_id, post_id, parent_comment_id, content, created_at, updated_at)
  - notifications (id, user_id, notifiable_type, notifiable_id, notification_type, read_at, created_at)
  - friendships (id, user_id, friend_id, status, created_at, updated_at)
```

---

## Key Dependencies

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5

Phase 2: Blocked until Phase 1 completes
Phase 3: Blocked until Phase 2 completes (partially can start with Phase 2)
Phase 4: Can start parallel with Phase 3, but Phase 5 blocked until Phase 4 completes
```

---

## Git Workflow

- **Main Branch**: Production-ready code
- **Dev Branch**: Integration branch for features
- **Feature Branches**: `feature/US-X.X-description`
  - Example: `feature/US-1.1-device-authentication-signup`

---

## Acceptance Criteria Checklist Template

```markdown
## US-X.X: [User Story Name]

### Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Testing
- [ ] Unit tests written
- [ ] Integration tests written
- [ ] Manual testing completed
- [ ] Edge cases handled

### Code Quality
- [ ] Code reviewed
- [ ] No linting errors
- [ ] Performance acceptable
- [ ] Documentation updated
```

---

## Commits Convention

```
[US-X.X] Brief description of change

Detailed explanation if needed:
- Bullet point 1
- Bullet point 2
```

---

## Deployment Checklist

- [ ] All tests passing
- [ ] Database migrations reviewed
- [ ] Environment variables configured
- [ ] Action Cable properly configured for production
- [ ] Assets compiled
- [ ] Performance tested
- [ ] Security audit completed

---

## Notes

- **Real-time Updates**: All features use Action Cable and Hotwire Stimulus for seamless real-time experience
- **Image Handling**: Use Rails Active Storage for image uploads
- **Authentication**: Utilize Devise gem with secure defaults
- **Database**: PostgreSQL is required for full compatibility

---

**Last Updated**: February 18, 2026
