# frozen_string_literal: true

class UsersController < ApplicationController
  skip_authentication_requirement! only: :search

  # GET/POST /users/search
  # Supports both HTML (form submission) and JSON (real-time search)
  def search
    @query = params[:q].to_s.strip

    # Use SearchService for consistent search logic
    service = Users::SearchService.new(@query)
    @users = service.search

    respond_to do |format|
      format.html { render :search_results }
      format.json do
        results = service.search_with_details
        Rails.logger.info("Search: query='#{@query}' results=#{results.count}")
        render json: { users: results, query: @query, count: results.count }
      end
    end
  rescue StandardError => e
    Rails.logger.error("Search error: #{e.message}\n#{e.backtrace.join("\n")}")
    respond_to do |format|
      format.json { render json: { error: "Search failed", users: [] }, status: :internal_server_error }
    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end
end
