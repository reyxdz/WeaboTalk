# frozen_string_literal: true

class Users::UserMailer < ApplicationMailer
  default from: ENV['MAIL_FROM'] || 'noreply@wabotalk.com'

  def confirmation_instructions(user, token = nil)
    @user = user
    @token = token || user.confirmation_token
    @confirmation_url = confirmation_url(user, confirmation_token: @token)

    mail(
      to: user.unconfirmed_email.presence || user.email,
      subject: 'Welcome to WeaboTalk! Please confirm your email'
    )
  end

  def reset_password_instructions(user, token, _opts = {})
    @user = user
    @reset_password_url = reset_password_url(user, reset_password_token: token)

    mail(to: user.email, subject: 'Reset your WeaboTalk password')
  end

  def unlock_instructions(user, token)
    @user = user
    @unlock_url = unlock_url(user, unlock_token: token)

    mail(to: user.email, subject: 'Account unlock')
  end

  private

  def confirmation_url(user, confirmation_token:)
    Rails.application.routes.url_helpers.user_confirmation_url(
      confirmation_token: confirmation_token,
      host: ENV['APP_HOST'] || 'localhost:3000'
    )
  end

  def reset_password_url(user, token:)
    Rails.application.routes.url_helpers.edit_user_password_url(
      reset_password_token: token,
      host: ENV['APP_HOST'] || 'localhost:3000'
    )
  end

  def unlock_url(user, token:)
    Rails.application.routes.url_helpers.user_unlock_url(
      unlock_token: token,
      host: ENV['APP_HOST'] || 'localhost:3000'
    )
  end
end
