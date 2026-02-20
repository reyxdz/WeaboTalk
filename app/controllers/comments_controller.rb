# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [ :destroy ]
  before_action :authorize_user!, only: [ :destroy ]

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@post), notice: "Comment was successfully created." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :form_error, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/:post_id/comments/:id
  def destroy
    @comment.destroy
    redirect_to post_path(@post), notice: "Comment was successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "Not authorized." unless current_user.id == @comment.user_id
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_comment_id)
  end
end
