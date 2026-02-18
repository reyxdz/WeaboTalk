# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout "devise"
    
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    def new
      super
    end

    # POST /resource
    def create
      build_resource(sign_up_params)

      resource.save
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        resource.errors.delete(:password_confirmation) if resource.errors.include?(:password_confirmation)
        respond_with resource
      end
    end

    # GET /resource/edit
    def edit
      super
    end

    # PUT /resource
    def update
      super
    end

    # DELETE /resource
    def destroy
      super
    end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    def cancel
      super
    end

    protected

    def after_sign_up_path_for(resource)
      # Redirect to confirmation pending page instead of root
      new_user_confirmation_path
    end

    def after_inactive_sign_up_path_for(resource)
      # For confirmable users, show confirmation pending page
      new_user_confirmation_path
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:email])
    end
  end
end
