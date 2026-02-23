# app/models/reaction.rb
# Reaction Model - Handles emoji reactions on posts
# MEMBER 3 RESPONSIBILITY: Social Interactions & Notifications
#
# === Attributes ===
# - user_id: references user
# - post_id: references post
# - reaction_type: string (emoji: 😍, 😂, 😢, 😡, 👍, etc.)
# - created_at, updated_at: timestamps
#
# === Associations ===
# belongs_to :user
# belongs_to :post
# has_many :notifications, as: :notifiable, dependent: :destroy
#
# === Validations ===
# user_id + post_id + reaction_type should be unique

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

  private

  def notify_post_author
    # TODO: Implement notification creation (US-3.7)
    # Trigger notification for post author about new reaction
  end
end
