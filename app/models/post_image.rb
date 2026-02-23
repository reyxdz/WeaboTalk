# frozen_string_literal: true

class PostImage < ApplicationRecord
  belongs_to :post
  has_one_attached :image, dependent: :purge

  validates :image, presence: true

  validate :image_file_type
  validate :image_file_size

  private

  def image_file_type
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
      errors.add(:image, "must be a valid image format (JPEG, PNG, GIF, or WebP)")
    end
  end

  def image_file_size
    return unless image.attached?

    if image.byte_size > 10.megabytes
      errors.add(:image, "file size must be less than 10MB")
    end
  end
end
