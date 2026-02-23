# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    layout "devise"

    # GET /resource/confirmation/new
    def new
      super
      @user_email = params[:email] || resource.email
    end

    # POST /resource/confirmation
    def create
      self.resource = resource_class.send_confirmation_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        respond_with({}, location: root_path) do |format|
          format.html { redirect_to root_path, notice: "Confirmation instructions sent successfully." }
        end
      else
        respond_with(resource)
      end
    end

    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        set_flash_message!(:notice, :confirmed)
        sign_in(resource_name, resource)
        # Render confirmation success page instead of redirecting
        render :confirmed
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
      end
    end

    protected

    def after_confirmation_path_for(resource_name, resource)
      root_path
    end
  end
end
