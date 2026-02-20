# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend_user, only: [ :create ]

  # POST /friendships
  def create
    @friendship = current_user.friendships.build(friend: @friend_user, status: "pending")

    if @friendship.save
      respond_to do |format|
        format.turbo_stream { render :create }
        format.html { redirect_to profile_path(@friend_user.profile.username), notice: "Friend request sent" }
        format.json { render json: { status: "success", message: "Friend request sent" } }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :error, status: :unprocessable_entity }
        format.html { redirect_to root_path, alert: @friendship.errors.full_messages.join(" ") }
        format.json { render json: { status: "error", message: @friendship.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friendships/:id/accept
  def update
    @friendship = Friendship.find(params[:id])

    if current_user.id == @friendship.friend_id
      if @friendship.accept!
        respond_to do |format|
          format.turbo_stream { render :update }
          format.html { redirect_to profile_path(@friendship.user.profile.username), notice: "Friend request accepted." }
        end
      else
        respond_to do |format|
          format.turbo_stream { render :error, status: :unprocessable_entity }
          format.html { redirect_to root_path, alert: "Could not accept friend request." }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render :error, status: :unprocessable_entity }
        format.html { redirect_to root_path, alert: "Not authorized." }
      end
    end
  end

  # DELETE /friendships/:id
  def destroy
    @friendship = current_user.friendships.find(params[:id])
    friend = @friendship.friend
    @friendship.destroy

    respond_to do |format|
      format.turbo_stream { render :destroy }
      format.html { redirect_to profile_path(friend.profile.username), notice: "Friend removed" }
      format.json { render json: { status: "success", message: "Friendship removed" } }
    end
  end

  # GET /friend-requests
  def pending_requests
    @pending_requests = current_user.friend_requests.pending.includes(:user)
  end

  # GET /friends
  def index
    @friends = current_user.friends.includes(:profile)
  end

  private

  def set_friend_user
    @friend_user = User.find(params[:friend_id])
  end
end
