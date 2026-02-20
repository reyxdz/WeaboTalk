# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :user_id, uniqueness: { scope: :post_id, message: "can like a post only once" }

  after_create :notify_post_author
  after_destroy :cleanup_notifications

  private

  def notify_post_author
    return if user == post.user

    Notification.create!(
      user: post.user,
      notification_type: "like_created",
      notifiable: self
    )

    NotificationsChannel.broadcast_to(
      post.user,
      { type: "like", post_id: post.id, user_id: user.id }
    )
  end

  def cleanup_notifications
    notifications.destroy_all
  end
end
