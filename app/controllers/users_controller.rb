# frozen_string_literal: true

class UsersController < ApplicationController
  # GET /users/search
  def search
    @query = params[:q]
    @users = if @query.present?
               Profile.where("username ILIKE ?", "%#{@query}%")
                      .includes(:user)
                      .limit(20)
    else
               []
    end

    respond_to do |format|
      format.html { render :search_results }
      format.json { render json: @users.map { |p| { id: p.user_id, username: p.username, avatar: p.avatar.attached? ? url_for(p.avatar) : nil } } }
    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end
end
