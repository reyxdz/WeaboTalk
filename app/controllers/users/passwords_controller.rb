# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    layout "devise"

    # GET /resource/password/new
    # def new
    #   super
    # end

    # POST /resource/password
    # def create
    #   super
    # end

    # GET /resource/password/edit?reset_password_token=abcdef
    # def edit
    #   super
    # end

    # PUT /resource/password
    # def update
    #   super
    # end

    protected

    # Customize the redirect path after a successful password reset
    def after_resetting_password_path_for(resource)
      super(resource) || new_user_session_path
    end

    # The path used after sending reset password instructions email
    def after_sending_reset_password_instructions_path_for(resource_name)
      user_session_path # Redirect to sign in page with message
    end

    # You can put the params you permit to update your model here.
    # def password_params
    #   params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
    # end
  end
end
