# app/models/post.rb
# Post Model - Handles user posts with title, content, and images
# MEMBER 2 RESPONSIBILITY: Post Creation & Media Management
#
# === Attributes ===
# - user_id: references user
# - title: string
# - content: text
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :user
# has_many :post_images, dependent: :destroy
# has_many :comments, dependent: :destroy
# has_many :likes, dependent: :destroy
# has_many :reactions, dependent: :destroy
# has_many :notifications, dependent: :destroy
#
# === Active Storage ===
# accepts_nested_attributes_for :post_images

class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  accepts_nested_attributes_for :post_images, reject_if: :all_blank?, allow_destroy: true

  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :content, presence: true, length: { minimum: 1, maximum: 5000 }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  # TODO: Add image upload validation (US-2.2)
  # TODO: Add edit timestamp tracking (US-2.3)
  # TODO: Add pagination scope
end
