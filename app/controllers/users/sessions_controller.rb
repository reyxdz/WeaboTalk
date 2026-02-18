# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    layout "devise"

    # POST /resource/sign_in
    def create
      # Check if user exists but is unconfirmed
      user = User.find_by(email: user_params[:email])
      
      if user && !user.confirmed?
        # User exists but hasn't confirmed email yet
        redirect_to new_user_confirmation_path(email: user.email), 
                    alert: "Please confirm your email first. We've sent you a confirmation link."
        return
      end

      super
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :remember_me)
    end
  end
end
