# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  NOTIFICATION_TYPES = %w[
    comment_created
    like_created
    reaction_created
    friend_request_sent
    friend_request_accepted
  ].freeze

  validates :user_id, presence: true
  validates :notification_type, presence: true, inclusion: { in: NOTIFICATION_TYPES }
  validates :notifiable_type, presence: true
  validates :notifiable_id, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def marked_as_read?
    read_at.present?
  end

  def unread?
    read_at.nil?
  end

  def mark_as_read!
    update(read_at: Time.current) unless marked_as_read?
  end

  class << self
    def unread_count_for_user(user)
      user.notifications.unread.count
    end
  end
end
