# app/models/user.rb
# User Model - Handles authentication and user data
# MEMBER 1 RESPONSIBILITY: Authentication & User Management
#
# === Devise Attributes ===
# - email: string
# - encrypted_password: string
# - created_at, updated_at: timestamps
#
# === Associations ===
# has_one :profile
# has_many :posts
# has_many :comments
# has_many :likes
# has_many :reactions
# has_many :friendships
# has_many :notifications
#
# === Devise Modules ===
# - :database_authenticatable
# - :registerable
# - :recoverable
# - :rememberable
# - :validatable

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Callbacks
  after_create :create_profile

  # Validations
  validates :email, presence: true, uniqueness: true

  # TODO: Setup more validations per US-1.2, US-1.3, US-1.4

  private

  def create_profile
    Profile.create(user_id: id)
  end
end
