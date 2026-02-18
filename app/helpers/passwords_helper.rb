# frozen_string_literal: true

module PasswordsHelper
  # Check if password reset token is valid
  def password_reset_token_valid?(user)
    return false unless user.reset_password_sent_at.present?
    user.reset_password_sent_at > 6.hours.ago
  end

  # Get password reset token expiration time
  def password_reset_expiration_time
    6.hours
  end

  # Check if user can request a password reset
  def can_request_password_reset?
    user_signed_in? || !user_signed_in?
  end

  # Display password reset instructions link
  def password_reset_link(text = "Forgot your password?", classes = "text-indigo-600 hover:text-indigo-700 font-semibold")
    link_to text, new_user_password_path, class: classes
  end

  # Password strength indicator
  def password_strength(password)
    return :weak if password.blank? || password.length < 8
    
    has_numbers = password.match?(/\d/)
    has_symbols = password.match?(/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/)
    has_uppercase = password.match?(/[A-Z]/)
    
    strength_count = [has_numbers, has_symbols, has_uppercase].count(true)
    
    case strength_count
    when 0, 1
      :weak
    when 2
      :medium
    else
      :strong
    end
  end
end
