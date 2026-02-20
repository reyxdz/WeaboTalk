# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  before_action :set_profile, only: [ :show, :edit, :update ]
  before_action :authorize_user!, only: [ :edit, :update ]

  # GET /profiles/:username
  def show
    @user = @profile.user
    @is_own_profile = current_user&.profile == @profile
    @posts = @user.posts.recent.includes(:user, :post_images, :comments, :likes, :reactions)
    @posts_count = @user.posts.count
    @friends_count = @user.friends.count
  end

  # GET /profiles/:username/edit
  def edit
    @user = @profile.user
  end

  # PATCH/PUT /profiles/:username
  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile.username),
                  notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find_by!(username: params[:username])
  end

  def authorize_user!
    redirect_to root_path, alert: "Not authorized." unless current_user == @profile.user
  end

  def profile_params
    params.require(:profile).permit(:username, :bio, :avatar, :banner)
  end
end
