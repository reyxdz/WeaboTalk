# frozen_string_literal: true

module SessionsHelper
  # Check if the current user is authenticated
  def user_authenticated?
    user_signed_in?
  end

  # Get the current user's display name
  def current_user_display_name
    return unless user_signed_in?
    current_user.email.split("@").first.capitalize
  end

  # Check if user has confirmed email
  def user_email_confirmed?
    return false unless user_signed_in?
    current_user.confirmed?
  end

  # Get sign out link with proper styling
  def sign_out_link(classes = "text-red-600 hover:text-red-700")
    link_to "Sign Out", user_session_path, method: :delete, class: classes
  end

  # Get sign in link with proper styling
  def sign_in_link(text = "Sign In", classes = "text-indigo-600 hover:text-indigo-700")
    link_to text, user_session_path, class: classes
  end

  # Get sign up link with proper styling
  def sign_up_link(text = "Sign Up", classes = "px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700")
    link_to text, new_user_registration_path, class: classes
  end
end
