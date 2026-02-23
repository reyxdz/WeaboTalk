# frozen_string_literal: true

class CommentNotificationJob < ApplicationJob
  queue_as :default

  # Accepts a comment id so the job is resilient across serialization boundaries.
  def perform(comment_id)
    comment = Comment.find_by(id: comment_id)
    return unless comment

    Notifications::CommentNotifier.new(comment).call
  end
end
