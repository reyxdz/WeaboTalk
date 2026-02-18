# app/models/like.rb
# Like Model - Handles user likes on posts
# MEMBER 3 RESPONSIBILITY: Social Interactions & Notifications
#
# === Attributes ===
# - user_id: references user
# - post_id: references post
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :user
# belongs_to :post
# has_many :notifications, as: :notifiable, dependent: :destroy
#
# === Validations ===
# user_id + post_id should be unique (user can like post only once)

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :user_id, uniqueness: { scope: :post_id, message: "can like a post only once" }

  after_create :notify_post_author

  private

  def notify_post_author
    # TODO: Implement notification creation (US-3.7)
    # Trigger notification for post author about new like
  end
end
