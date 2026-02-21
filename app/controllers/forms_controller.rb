# frozen_string_literal: true

class FormsController < ApplicationController
  skip_authentication_requirement!

  # POST /forms/validate
  # Accept AJAX requests to validate individual form fields
  def validate
    field_name = params[:field]
    value = params[:value]
    password_value = params[:password] # for password confirmation validation
    form_type = params[:form_type] || "generic"

    # Extract the field name from nested attributes (e.g., "post[title]" -> "title", "comment[content]" -> "comment_content")
    extracted_field = extract_field_name(field_name, form_type)

    errors = Forms::ValidationRules.validate(extracted_field, value, password_value)

    respond_to do |format|
      format.json do
        render json: { errors: errors, field: field_name }
      end
    end
  end

  private

  def skip_authentication_requirement!
    # This controller should be publicly accessible for validation
  end

  # Map form field names to validation rule keys
  def extract_field_name(field_name, form_type)
    # Handle nested form field names like "post[title]", "comment[content]", etc.
    case field_name
    when /\[content\]$/, /^comment.*content/
      "comment_content"
    when /\[bio\]$/
      "bio"
    when /\[username\]$/
      "username"
    when /\[password_confirmation\]$/, /password_confirmation/
      "password_confirmation"
    when /\[password\]$/, /^user.*password(?!_confirmation)/
      "password"
    when /\[email\]$/, /^user.*email/
      "email"
    when /\[title\]$/
      "title"
    when /\[content\]$/
      "content"
    else
      # Return the clean field name
      field_name.gsub(/^[\w\[]*\[/, "").gsub(/\]$/, "")
    end
  end
end

