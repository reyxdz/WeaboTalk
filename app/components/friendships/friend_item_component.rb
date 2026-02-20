# frozen_string_literal: true

module Friendships
  class FriendItemComponent < ViewComponent::Base
    attr_reader :friend, :current_user

    def initialize(friend:, current_user:)
      @friend = friend
      @current_user = current_user
    end

    def friend_username
      friend&.profile&.username || friend&.email&.split("@")&.first
    end

    def friend_profile_path
      profile_path(friend&.profile&.username || friend.id)
    end

    def friend_bio
      friend&.profile&.bio || "No bio yet"
    end

    def friendship_id
      Friendship.find_by(user_id: current_user.id, friend_id: friend.id)&.id
    end
  end
end
