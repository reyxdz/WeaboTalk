# app/models/notification.rb
# Notification Model - Handles real-time notifications for users
# MEMBER 3 RESPONSIBILITY: Social Interactions & Notifications
#
# === Attributes ===
# - user_id: references user (recipient)
# - notifiable_type: string (polymorphic - Comment, Like, Reaction, Friendship, etc.)
# - notifiable_id: integer (polymorphic ID)
# - notification_type: string (comment_created, like_created, reaction_created, friend_request_sent)
# - read_at: datetime (null until marked as read)
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :user
# belongs_to :notifiable, polymorphic: true
#
# === Scopes ===
# unread: notifications that haven't been read yet
# recent: ordered by newest first

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  NOTIFICATION_TYPES = %w[
    comment_created
    like_created
    reaction_created
    friend_request_sent
    friend_request_accepted
  ].freeze

  validates :user_id, presence: true
  validates :notification_type, presence: true, inclusion: { in: NOTIFICATION_TYPES }
  validates :notifiable_type, presence: true
  validates :notifiable_id, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def marked_as_read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.current) unless marked_as_read?
  end

  def unread_count_for_user(user)
    user.notifications.unread.count
  end

  # TODO: Add ActionCable broadcasting (US-3.3)
  # Broadcast to user's notification channel when created
end
