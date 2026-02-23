# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  # POST /posts/:post_id/likes
  def create
    @like = @post.likes.find_or_create_by(user: current_user)

    respond_to do |format|
      format.turbo_stream 
      format.html { redirect_back fallback_location: root_path }
      # format.html { redirect_to post_path(@post), notice: "Post liked!" }
      format.json { render json: { status: "success", likes_count: @post.likes.count } }
    end
  end

  # DELETE /posts/:post_id/likes/:id
  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like&.destroy

    respond_to do |format|
      format.turbo_stream #{ render :update_likes }
      format.html { redirect_back fallback_location: root_path }
      # format.html { redirect_to post_path(@post), notice: "Post unliked!" }
      format.json { render json: { status: "success", likes_count: @post.likes.count } }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
