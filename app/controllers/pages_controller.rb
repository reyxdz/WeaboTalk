# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    # Home page route - show authenticated user feed or landing page
    if user_signed_in?
      @pagy, @posts = pagy(Post.recent.includes(:user, :post_images, :comments, :likes, :reactions), items: 20)
    end
  end
end
