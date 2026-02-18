# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_one_attached :avatar, dependent: :purge
  has_one_attached :banner, dependent: :purge

  # Validations
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" }
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :user_id, presence: true

  # Scopes
  scope :with_avatar, -> { where.associated(:avatar_attachment) }
  scope :with_banner, -> { where.associated(:banner_attachment) }

  # Avatar validation
  validate :avatar_file_size
  validate :avatar_file_type

  private

  def avatar_file_size
    return unless avatar.attached?
    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, "file size must be less than 5MB")
    end
  end

  def avatar_file_type
    return unless avatar.attached?
    unless avatar.content_type.in?(%w(image/jpeg image/png image/gif image/webp))
      errors.add(:avatar, "must be a valid image format (JPEG, PNG, GIF, or WebP)")
    end
  end
end
