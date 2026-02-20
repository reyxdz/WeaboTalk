# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :index ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  # GET /posts or /posts.turbo_stream
  def index
    @pagy, @posts = pagy(Post.recent.includes(:user, :post_images, :comments, :likes, :reactions), items: 20)
    respond_to do |format|
      format.html
      format.turbo_stream
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
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_path(@post), notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
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
