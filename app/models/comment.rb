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

  after_create :enqueue_notify_post_author
  after_destroy :cleanup_notifications

  private

  # Enqueue a background job to notify the post author about this comment.
  # Keeping the model callback, but delegating side-effects to a job/service
  # improves testability and separates concerns.
  def enqueue_notify_post_author
    CommentNotificationJob.perform_later(id)
  end

  def cleanup_notifications
    notifications.destroy_all
  end
end
