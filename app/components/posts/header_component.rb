# frozen_string_literal: true

module Posts
  class HeaderComponent < ViewComponent::Base
    attr_reader :post, :current_user

    def initialize(post:, current_user: nil)
      @post = post
      @current_user = current_user
    end

    def is_post_owner?
      current_user && current_user.id == post.user_id
    end

    def username
      post.user.profile&.username || post.user.email
    end

    def user_profile_path
      profile_path(post.user.profile&.username || post.user.id)
    end

    def time_since_creation
      time_ago_in_words(post.created_at)
    end

    def is_edited?
      post.updated_at != post.created_at
    end
  end
end
