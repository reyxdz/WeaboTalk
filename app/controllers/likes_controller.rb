# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

# POST /posts/:post_id/likes
def create
  @post = Post.find(params[:post_id])
  @like = @post.likes.create(user: current_user)

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to @post }
  end
end
# DELETE /posts/:post_id/likes/:id

def destroy
  @post = Post.find(params[:post_id])
  @like = @post.likes.find_by(user: current_user)
  @like.destroy if @like

  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to @post }
  end
end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
