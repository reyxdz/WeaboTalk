# frozen_string_literal: true

module Profiles
  class ImageComponent < ViewComponent::Base
    attr_reader :user, :size, :css_class

    def initialize(user:, size: "md", css_class: "")
      @user = user
      @size = size
      @css_class = css_class
    end

    def size_classes
      case @size
      when "xs"
        "w-8 h-8"
      when "sm"
        "w-10 h-10"
      when "md"
        "w-12 h-12"
      when "lg"
        "w-16 h-16"
      when "xl"
        "w-24 h-24"
      else
        "w-12 h-12"
      end
    end

    def avatar_url
      user&.profile&.avatar&.attached? ? user.profile.avatar : nil
    end

    def initials
      username = user&.profile&.username || user&.email
      username.split.map(&:first).join.upcase[0..1]
    end

    def username
      user&.profile&.username || user&.email&.split("@")&.first
    end
  end
end
