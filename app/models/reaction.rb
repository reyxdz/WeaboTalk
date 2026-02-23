# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  ALLOWED_REACTIONS = %w[😍 😂 😢 😡 👍 🔥 💯 ❤️ 🎉].freeze

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :reaction_type, presence: true, inclusion: { in: ALLOWED_REACTIONS }
  validates :user_id, uniqueness: { scope: [ :post_id, :reaction_type ],
                                    message: "can use this reaction on post only once" }

  after_create :notify_post_author
  after_destroy :cleanup_notifications

  private

  def notify_post_author
    return if user == post.user

    Notification.create!(
      user: post.user,
      notification_type: "reaction_created",
      notifiable: self
    )

    NotificationsChannel.broadcast_to(
      post.user,
      { type: "reaction", post_id: post.id, user_id: user.id, reaction_type: reaction_type }
    )
  end

  def cleanup_notifications
    notifications.destroy_all
  end
end
