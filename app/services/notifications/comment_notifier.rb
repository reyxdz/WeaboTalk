# frozen_string_literal: true

module Notifications
  class CommentNotifier
    def initialize(comment)
      @comment = comment
      @post = comment.post
      @recipient = @post.user
      @actor = comment.user
    end

    # Create a Notification record and broadcast to the recipient's channel.
    # This is extracted from the model to keep side-effects out of ActiveRecord callbacks.
    def call
      return if @actor == @recipient

      Notification.create!(
        user: @recipient,
        notification_type: "comment_created",
        notifiable: @comment
      )

      NotificationsChannel.broadcast_to(
        @recipient,
        { type: "comment", post_id: @post.id, user_id: @actor.id }
      )
    end
  end
end
