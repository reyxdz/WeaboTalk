# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  # POST /posts/:post_id/reactions
  def create
    existing = @post.reactions.find_by(user: current_user, reaction_type: reaction_params[:reaction_type])

    if existing
      existing.destroy
      @reaction = nil
    else
      @reaction = @post.reactions.create(user: current_user, reaction_type: reaction_params[:reaction_type])
    end

    respond_to do |format|
      format.turbo_stream { render :update_reactions }
      format.html { redirect_to root }
      format.json { render json: { status: "success", reactions: @post.reactions.group_by(&:reaction_type).map { |k, v| { type: k, count: v.length } } } }
    end
  end

  # DELETE /posts/:post_id/reactions/:id
  def destroy
    @reaction = @post.reactions.find(params[:id])
    @reaction.destroy

    respond_to do |format|
      format.turbo_stream { render :update_reactions }
      format.html { redirect_to post_path(@post) }
      format.json { render json: { status: "success", reactions: @post.reactions.group_by(&:reaction_type).map { |k, v| { type: k, count: v.length } } } }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def reaction_params
    params.require(:reaction).permit(:reaction_type)
  end
end
