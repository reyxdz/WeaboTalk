# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  # GET /notifications
  def index
    @pagy, @notifications = pagy(current_user.notifications.recent.includes(:notifiable), items: 20)
  end

  # PATCH /notifications/:id/mark-as-read
  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!

    respond_to do |format|
      format.turbo_stream { render :mark_as_read }
      format.json { render json: { status: "success" } }
      format.html { redirect_to notifications_path, notice: "Notification marked as read." }
    end
  end

  # PATCH /notifications/mark-all-as-read
  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)

    respond_to do |format|
      format.turbo_stream { redirect_to notifications_path, notice: "All notifications marked as read." }
      format.json { render json: { status: "success" } }
      format.html { redirect_to notifications_path, notice: "All notifications marked as read." }
    end
  end

  # DELETE /notifications/:id
  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.turbo_stream { render :destroy }
      format.json { render json: { status: "success" } }
      format.html { redirect_to notifications_path, notice: "Notification deleted." }
    end
  end
end
