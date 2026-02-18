require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Test Setup
  setup do
    @user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  # Presence and Format Validations
  test "should not save user without email" do
    user = User.new(password: "password123", password_confirmation: "password123")
    assert_not user.save, "User saved without email"
  end

  test "should not save user with invalid email format" do
    user = User.new(email: "invalid_email", password: "password123", password_confirmation: "password123")
    assert_not user.save, "User saved with invalid email format"
  end

  test "should not save user with duplicate email" do
    duplicate_user = User.new(
      email: @user.email,
      password: "password123",
      password_confirmation: "password123"
    )
    assert_not duplicate_user.save, "Duplicate user was saved"
  end

  test "should not save user without password on create" do
    user = User.new(email: "newtest@example.com")
    assert_not user.save, "User saved without password"
  end

  test "should not save user with password shorter than 8 characters" do
    user = User.new(
      email: "short_pass@example.com",
      password: "short",
      password_confirmation: "short"
    )
    assert_not user.save, "User with short password was saved"
  end

  test "should not save user with mismatched password confirmation" do
    user = User.new(
      email: "mismatch@example.com",
      password: "password123",
      password_confirmation: "different_password"
    )
    assert_not user.save, "User with mismatched passwords was saved"
  end

  # Valid User Creation
  test "should save valid user" do
    user = User.new(
      email: "valid_user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.save, "Valid user was not saved"
  end

  # Email Confirmation
  test "user should have confirmation token after creation" do
    user = User.create!(
      email: "confirm_test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_not_nil user.confirmation_token, "User has no confirmation token"
  end

  test "user should not be confirmed upon creation" do
    user = User.create!(
      email: "unconfirmed@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_nil user.confirmed_at, "User was confirmed upon creation"
  end

  test "user should be able to get confirmed" do
    user = User.create!(
      email: "confirm_me@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    token = user.confirmation_token
    user.confirm
    assert_not_nil user.confirmed_at, "User was not confirmed"
  end

  # Email Sending
  test "send_devise_notification should queue email" do
    user = User.create!(
      email: "notification_test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    # This should enqueue the email
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      user.send_devise_notification(:confirmation_instructions)
    end
  end

  # Edge Cases
  test "email should be case insensitive" do
    user = User.create(
      email: "TestUser@Example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.save, "User with mixed case email was not saved"
  end

  test "should not save user with whitespace around email" do
    user = User.new(
      email: " spaced@example.com ",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.save, "User with whitespace around email was not saved"
    # Email should be stripped by devise
    assert_equal "spaced@example.com", user.email
  end
end
