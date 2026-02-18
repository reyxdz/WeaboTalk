# Action Cable & Real-time Notifications Setup Guide
# MEMBER 3 RESPONSIBILITY
#
# Action Cable enables real-time, bidirectional communication via WebSocket
# This is critical for notifications, real-time updates to likes/comments

## Overview

Action Cable consists of:
1. **Channels** (app/channels/) - Server-side WebSocket handlers
2. **Connection** (app/channels/application_cable/connection.rb) - Authenticates users
3. **Subscriptions** (client-side) - Stimulus controllers handle real-time updates
4. **Broadcasting** - Server sends data to connected clients

---

## Step 1: Setup Connection Authentication

File: app/channels/application_cable/connection.rb

```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.id
    end

    protected

    def find_verified_user
      if verified_user = User.find_by(id: cookies.encrypted[:user_id])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
```

---

## Step 2: Create Notifications Channel

File: app/channels/notifications_channel.rb

```ruby
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe current user to their notification stream
    stream_for current_user
  end

  def unsubscribed
    # Called when user unsubscribes
  end

  def mark_as_read(data)
    notification = Notification.find(data['id'])
    notification.mark_as_read! if notification.user == current_user
  end
end
```

---

## Step 3: Broadcast Notifications from Models

File: app/models/comment.rb (after_create callback)

```ruby
after_create :broadcast_notification

private

def broadcast_notification
  # Create notification
  notification = Notification.create!(
    user_id: post.user_id,
    notifiable: self,
    notification_type: 'comment_created'
  )

  # Broadcast to post author's notification channel
  NotificationsChannel.broadcast_to(
    post.user,
    {
      id: notification.id,
      type: 'comment_created',
      message: "#{user.profile.username} commented on your post",
      data: {
        post_id: post.id,
        comment_id: id,
        author: user.profile.username
      }
    }
  )
end
```

---

## Step 4: Create Stimulus Controller for Notifications

File: app/javascript/controllers/notification_controller.js

```javascript
import { Controller } from "@hotwired/stimulus"
import * as ActionCable from "@rails/actioncable"

export default class extends Controller {
  static targets = ["bell", "count", "notificationList"]

  connect() {
    this.subscription = ActionCable.createConsumer().subscriptions.create(
      {
        channel: "NotificationsChannel"
      },
      {
        received: this.handleNotification.bind(this),
        connected: () => console.log("Notification channel connected")
      }
    )
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }

  handleNotification(data) {
    // Update notification bell
    this.updateNotificationCount()
    
    // Add new notification to list
    this.addNotificationToDOM(data)
    
    // Show notification toast/banner
    this.showNotificationToast(data)
  }

  updateNotificationCount() {
    fetch(`/notifications/unread_count`)
      .then(r => r.json())
      .then(data => {
        this.countTarget.textContent = data.count
        if (data.count > 0) {
          this.bellTarget.classList.add('has-notifications')
        }
      })
  }

  addNotificationToDOM(notification) {
    const notificationHTML = `
      <div class="notification-item" data-id="${notification.id}">
        <p>${notification.message}</p>
        <small>${new Date().toLocaleTimeString()}</small>
      </div>
    `
    this.notificationListTarget.insertAdjacentHTML('afterbegin', notificationHTML)
  }

  showNotificationToast(data) {
    // Show toast notification using Bootstrap/custom CSS
    const toast = document.createElement('div')
    toast.className = 'toast-notification'
    toast.textContent = data.message
    document.body.appendChild(toast)
    
    setTimeout(() => toast.remove(), 5000)
  }

  markAsRead(notificationId) {
    this.subscription.send({
      action: 'mark_as_read',
      id: notificationId
    });
  }
}
```

---

## Step 5: View Setup

File: app/views/layouts/_notification_bell.html.erb

```erb
<div data-controller="notification">
  <button class="notification-bell" data-notification-target="bell">
    🔔 <span data-notification-target="count">0</span>
  </button>

  <div class="notification-dropdown">
    <div class="notification-list" data-notification-target="notificationList">
      <!-- Notifications appear here -->
    </div>
  </div>
</div>
```

---

## Step 6: Test Action Cable Connection

1. Start Rails server: `./bin/dev`
2. Open browser console (F12)
3. Visit any authenticated page
4. Create a comment on another user's post
5. Check browser console for WebSocket messages
6. Verify notification appears in real-time

---

## Development Configuration

File: config/cable.yml

```yaml
development:
  adapter: async

test:
  adapter: test

production:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: "weanor_talk_"
```

---

## Production Deployment

For production, Action Cable requires:
1. Redis instance running
2. Update config/cable.yml to use Redis adapter
3. Configure WebSocket URL in production.rb
4. Set REDIS_URL environment variable

---

## Troubleshooting

### WebSocket Connection Issues
- Check browser console for WebSocket errors
- Verify Redis is running (if using Redis adapter)
- Check ActionCable logging in Rails console

### Notifications Not Appearing
- Verify broadcast_to is called in model
- Check Stimulus controller is properly connected
- Verify user is authenticated (connection.rb)

### Performance Issues
- Monitor Redis memory usage
- Consider message queue implementation
- Implement notification batching for high-volume scenarios

---

## Real-time Features Using Action Cable

✅ Notifications (comments, likes, reactions, friend requests)
✅ Live feed updates
✅ Online status indicators
✅ Real-time typing indicators (optional)
✅ Message notifications

---

**Last Updated**: February 18, 2026
