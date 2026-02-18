# app/models/friendship.rb
# Friendship Model - Handles friend relationships between users
# MEMBER 3 RESPONSIBILITY: Social Interactions & Notifications
#
# === Attributes ===
# - user_id: references user (requester)
# - friend_id: references user (target)
# - status: string (pending, accepted, blocked)
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :user
# belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
# has_many :notifications, as: :notifiable, dependent: :destroy
#
# === Validations ===
# user_id and friend_id should not be the same (can't friend yourself)
# user_id + friend_id should be unique (only one friendship request between two users)

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
  has_many :notifications, as: :notifiable, dependent: :destroy

  STATUSES = %w[pending accepted blocked].freeze

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: { scope: :friend_id, message: "can only have one friendship request per user" }
  validate :user_cannot_friend_self

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :blocked, -> { where(status: 'blocked') }

  after_create :notify_friend_request

  def accept!
    update(status: 'accepted')
  end

  def reject!
    destroy
  end

  def block!
    update(status: 'blocked')
  end

  private

  def user_cannot_friend_self
    errors.add(:friend_id, "cannot add yourself as a friend") if user_id == friend_id
  end

  def notify_friend_request
    # TODO: Implement notification creation (US-3.8)
    # Trigger notification for friend about friend request
  end
end
