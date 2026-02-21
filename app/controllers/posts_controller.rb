# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :index ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :publish ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy, :publish ]

  # GET /posts or /posts.turbo_stream
  def index
    @pagy, @posts = pagy(Post.published_only.recent.includes(:user, :post_images, :comments, :likes, :reactions), items: 20)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /my-drafts
  # List all draft posts for the current user
  def drafts
    @pagy, @drafts = pagy(current_user.posts.draft_only.recent.includes(:post_images), items: 20)
  end

  # POST /posts/save-draft
  # Smart handler for draft operations:
  # - New post + save: Create as draft
  # - New post + publish: Create as published
  # - Existing draft + save: Update draft
  # - Existing draft + publish: Publish the draft
  def save_draft
    # Handle both namespaced and non-namespaced params
    post_params = if params[:post]
                    params.require(:post).permit(:title, :content, :id, post_images_attributes: [ :id, :image, :_destroy ])
                  else
                    params.permit(:title, :content, :id, post_images_attributes: [ :id, :image, :_destroy ])
                  end
    
    action_type = params[:action_type] # 'save' or 'publish'
    draft_service = Posts::DraftService.new(current_user)

    # Handle publish action for new posts
    if action_type == "publish" && post_params[:id].blank?
      @post = current_user.posts.build(post_params.merge(status: :published))
      if @post.save
        redirect_to home_path, notice: "Post was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
      return
    end

    # Handle publish for existing drafts
    if action_type == "publish" && post_params[:id].present?
      result = draft_service.publish_draft(post_params[:id])
      success_redirect = home_path
      success_message = "Post published successfully."
      failure_redirect = drafts_posts_path
    else
      # Handle save (new or existing)
      result = draft_service.save_draft(post_params)
      success_redirect = drafts_posts_path
      success_message = "Draft saved successfully."
      failure_redirect = drafts_posts_path
    end

    respond_to do |format|
      if result[:success]
        format.json { render json: { status: "success", post_id: result[:post].id, message: success_message } }
        format.html { redirect_to success_redirect, notice: success_message }
      else
        format.json { render json: { status: "error", errors: result[:errors] }, status: :unprocessable_entity }
        format.html { redirect_to failure_redirect, alert: result[:errors].join(", ") }
      end
    end
  end

  # PATCH /posts/:id/publish
  # Publish a draft post (change status from draft to published)
  def publish
    draft_service = Posts::DraftService.new(current_user)
    result = draft_service.publish_draft(@post.id)

    respond_to do |format|
      if result[:success]
        format.json { render json: { status: "success", message: "Post published" } }
        format.html { redirect_to home_path, notice: "Post published successfully." }
      else
        format.json { render json: { status: "error", errors: result[:errors] }, status: :unprocessable_entity }
        format.html { redirect_to drafts_path, alert: result[:errors].join(", ") }
      end
    end
  end

  # GET /posts/:id
  def show
    @post = Post.includes(:user, :post_images, comments: :user, likes: :user, reactions: :user).find(params[:id])
    @comments = @post.comments.root_comments.includes(replies: :user, user: :profile)
    @comment = Comment.new
    @is_author = current_user&.id == @post.user_id
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/:id/edit
  def edit
    # Only drafts can be edited
    redirect_to drafts_posts_path, alert: "Cannot edit published posts." unless @post.draft?
  end

  # POST /posts
  # Creates and publishes a post immediately (not used for drafts)
  def create
    @post = current_user.posts.build(post_params.merge(status: :published))

    if @post.save
      redirect_to home_path, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  # Not used in clean architecture
  def update
    redirect_to home_path, alert: "Invalid action."
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "Not authorized." unless current_user.id == @post.user_id
  end

  def post_params
    params.require(:post).permit(:title, :content, post_images_attributes: [ :id, :image, :_destroy ])
  end
end
