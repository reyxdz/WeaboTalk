# app/models/comment.rb
# Comment Model - Handles user comments on posts
# MEMBER 3 RESPONSIBILITY: Social Interactions & Notifications
#
# === Attributes ===
# - user_id: references user
# - post_id: references post
# - parent_comment_id: references comment (for nested replies)
# - content: text
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :user
# belongs_to :post
# belongs_to :parent_comment, class_name: 'Comment', optional: true
# has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
# has_many :notifications, as: :notifiable, dependent: :destroy

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }

  scope :root_comments, -> { where(parent_comment_id: nil) }
  scope :recent, -> { order(created_at: :desc) }

  after_create :notify_post_author

  private

  def notify_post_author
    # TODO: Implement notification creation (US-3.6)
    # Trigger notification for post author about new comment
  end
end
