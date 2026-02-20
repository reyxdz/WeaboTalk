# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent_comment, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_comment_id", dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }

  scope :root_comments, -> { where(parent_comment_id: nil) }
  scope :recent, -> { order(created_at: :desc) }

  after_create :notify_post_author
  after_destroy :cleanup_notifications

  private

  def notify_post_author
    return if user == post.user

    Notification.create!(
      user: post.user,
      notification_type: "comment_created",
      notifiable: self
    )

    NotificationsChannel.broadcast_to(
      post.user,
      { type: "comment", post_id: post.id, user_id: user.id }
    )
  end

  def cleanup_notifications
    notifications.destroy_all
  end
end
