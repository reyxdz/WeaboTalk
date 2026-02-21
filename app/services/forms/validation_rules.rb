# frozen_string_literal: true

module Forms
  # Encapsulates validation rules for all forms in the application.
  # Returns validation errors based on field name, value, and optional constraints.
  class ValidationRules
    # Define validation rules for each field type
    RULES = {
      # User fields
      email: [
        { type: :presence, message: "Email is required" },
        { type: :email_format, message: "Please enter a valid email address" },
        { type: :min_length, value: 5, message: "Email must be at least 5 characters" }
      ],
      password: [
        { type: :presence, message: "Password is required" },
        { type: :min_length, value: 8, message: "Password must be at least 8 characters" },
        { type: :password_strength, message: "Password must contain letters, numbers, and special characters" }
      ],
      password_confirmation: [
        { type: :presence, message: "Password confirmation is required" },
        { type: :match, field: :password, message: "Passwords must match" }
      ],
      current_password: [
        { type: :presence, message: "Current password is required" }
      ],

      # Post fields
      title: [
        { type: :presence, message: "Title is required" },
        { type: :min_length, value: 3, message: "Title must be at least 3 characters" },
        { type: :max_length, value: 200, message: "Title must not exceed 200 characters" }
      ],
      content: [
        { type: :presence, message: "Content is required" },
        { type: :min_length, value: 1, message: "Content cannot be empty" },
        { type: :max_length, value: 5000, message: "Content must not exceed 5000 characters" }
      ],

      # Comment fields
      comment_content: [
        { type: :presence, message: "Comment cannot be empty" },
        { type: :min_length, value: 1, message: "Comment must have at least 1 character" },
        { type: :max_length, value: 1000, message: "Comment must not exceed 1000 characters" }
      ],

      # Profile fields
      username: [
        { type: :presence, message: "Username is required" },
        { type: :min_length, value: 3, message: "Username must be at least 3 characters" },
        { type: :max_length, value: 30, message: "Username must not exceed 30 characters" },
        { type: :username_format, message: "Username can only contain letters, numbers, and underscores" }
      ],
      bio: [
        { type: :max_length, value: 500, message: "Bio must not exceed 500 characters" }
      ]
    }.freeze

    def self.validate(field_name, value, password_value = nil)
      field_key = field_name.to_sym
      rules = RULES[field_key] || []

      errors = []
      rules.each do |rule|
        error = validate_rule(rule, value, password_value)
        errors << error if error.present?
      end

      errors
    end

    private

    def self.validate_rule(rule, value, password_value = nil)
      case rule[:type]
      when :presence
        rule[:message] if value.blank?
      when :min_length
        rule[:message] if value.present? && value.to_s.length < rule[:value]
      when :max_length
        rule[:message] if value.present? && value.to_s.length > rule[:value]
      when :email_format
        rule[:message] if value.present? && !email_valid?(value)
      when :password_strength
        rule[:message] if value.present? && !password_strong?(value)
      when :match
        rule[:message] if value.present? && value != password_value
      when :username_format
        rule[:message] if value.present? && !username_valid?(value)
      end
    end

    def self.email_valid?(email)
      /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(email)
    end

    def self.password_strong?(password)
      has_letter = /[a-zA-Z]/.match?(password)
      has_number = /\d/.match?(password)
      has_special = /[@$!%*?&]/.match?(password)
      has_letter && has_number && has_special
    end

    def self.username_valid?(username)
      /\A[a-zA-Z0-9_]+\z/.match?(username)
    end
  end
end
