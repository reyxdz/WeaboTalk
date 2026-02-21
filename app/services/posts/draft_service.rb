# frozen_string_literal: true

module Posts
  # Service object to handle draft post operations.
  # Encapsulates logic for creating, updating, and publishing drafts.
  class DraftService
    def initialize(user)
      @user = user
    end

    # Save or update a draft post.
    # Returns [success: bool, post: Post, errors: array]
    def save_draft(draft_params)
      draft_id = draft_params.delete(:id)
      
      post = if draft_id.present?
               @user.posts.draft.find_by(id: draft_id)
             end

      post ||= @user.posts.build

      if post.update(draft_params.merge(status: :draft))
        { success: true, post: post, errors: [] }
      else
        { success: false, post: post, errors: post.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      { success: false, post: nil, errors: ["Draft not found"] }
    end

    # Publish a draft (change status from draft to published).
    # Returns [success: bool, post: Post, errors: array]
    def publish_draft(draft_id)
      post = @user.posts.draft.find_by(id: draft_id)
      
      return { success: false, post: nil, errors: ["Draft not found"] } unless post

      if post.update(status: :published)
        { success: true, post: post, errors: [] }
      else
        { success: false, post: post, errors: post.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      { success: false, post: nil, errors: ["Draft not found"] }
    end

    # Fetch all drafts for the user.
    def user_drafts
      @user.posts.draft.recent
    end

    # Delete a draft.
    def delete_draft(draft_id)
      post = @user.posts.draft.find_by(id: draft_id)
      
      return { success: false, errors: ["Draft not found"] } unless post

      post.destroy
      { success: true, errors: [] }
    rescue ActiveRecord::RecordNotFound
      { success: false, errors: ["Draft not found"] }
    end
  end
end
