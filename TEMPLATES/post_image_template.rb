# app/models/post_image.rb
# PostImage Model - Handles images attached to posts
# MEMBER 2 RESPONSIBILITY: Post Creation & Media Management
#
# === Attributes ===
# - post_id: references post
# - image: ActiveStorage attachment
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :post
#
# === Active Storage ===
# has_one_attached :image

class PostImage < ApplicationRecord
  belongs_to :post
  has_one_attached :image

  validates :post_id, presence: true
  validates :image, presence: true

  # TODO: Add image size validation (max 10MB)
  # TODO: Add image format validation (JPG, PNG, WebP)
  # TODO: Add before_save to compress images
  # TODO: Add image processing for thumbnails
end
