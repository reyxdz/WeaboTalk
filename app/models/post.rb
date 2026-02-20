# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :post_images, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  accepts_nested_attributes_for :post_images, allow_destroy: true, reject_if: proc { |attrs| attrs["image"].blank? || (attrs["_destroy"] == "1") }

  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :content, presence: true, length: { minimum: 1, maximum: 5000 }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
end
