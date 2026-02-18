# app/models/profile.rb
# User Profile Model - Handles user profile information
# MEMBER 1 RESPONSIBILITY: Authentication & User Management
#
# === Attributes ===
# - user_id: references user
# - username: string (unique)
# - bio: text
# - avatar: ActiveStorage attachment
# - banner: ActiveStorage attachment
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :user
#
# === Active Storage ===
# has_one_attached :avatar
# has_one_attached :banner

class Profile < ApplicationRecord
  belongs_to :user

  has_one_attached :avatar
  has_one_attached :banner

  validates :user_id, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 30 }
  
  # TODO: Add validations for avatar and banner size
  # TODO: Add image processing for profile pictures
end
