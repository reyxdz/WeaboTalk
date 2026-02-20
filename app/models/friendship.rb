# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User", foreign_key: "friend_id"
  has_many :notifications, as: :notifiable, dependent: :destroy

  STATUSES = %w[pending accepted blocked].freeze

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: { scope: :friend_id, message: "can only have one friendship request per user" }
  validate :user_cannot_friend_self

  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
  scope :blocked, -> { where(status: "blocked") }

  after_create :notify_friend_request
  after_destroy :cleanup_notifications, :destroy_reverse_friendship

  def accept!
    update(status: "accepted")
    create_reverse_friendship unless reverse_friendship_exists?
    notify_acceptance
  end

  def reject!
    destroy
  end

  def block!
    update(status: "blocked")
  end

  private

  def user_cannot_friend_self
    errors.add(:friend_id, "cannot add yourself as a friend") if user_id == friend_id
  end

  def notify_friend_request
    Notification.create!(
      user: friend,
      notification_type: "friend_request_sent",
      notifiable: self
    )

    NotificationsChannel.broadcast_to(
      friend,
      { type: "friend_request", user_id: user.id }
    )
  end

  def notify_acceptance
    Notification.create!(
      user: user,
      notification_type: "friend_request_accepted",
      notifiable: self
    )

    NotificationsChannel.broadcast_to(
      user,
      { type: "friend_request_accepted", friend_id: friend.id }
    )
  end

  def reverse_friendship_exists?
    Friendship.exists?(user_id: friend_id, friend_id: user_id, status: "accepted")
  end

  def create_reverse_friendship
    Friendship.create!(user_id: friend_id, friend_id: user_id, status: "accepted")
  end

  def cleanup_notifications
    notifications.destroy_all
  end

  def destroy_reverse_friendship
    reverse = Friendship.find_by(user_id: friend_id, friend_id: user_id)
    reverse&.destroy
  end
end
