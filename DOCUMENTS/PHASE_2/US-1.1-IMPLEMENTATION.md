# US-1.1: Device Authentication - Sign Up - Implementation Guide

## Overview
This document provides comprehensive details about the implementation of User Sign Up functionality with email validation and account activation in WeaboTalk.

## Architecture

### 1. Database Layer
**Migration**: `20260218030000_add_confirmable_to_users.rb`
- Adds confirmation token, confirmed_at, confirmation_sent_at, and unconfirmed_email columns
- Allows Devise to manage email confirmation workflow

### 2. Model Layer
**File**: `app/models/user.rb`
- Uses Devise's `:confirmable` module
- Custom validations for email and password strength
- Custom mailer integration to use `Users::UserMailer`

**Key Validations**:
- Email must be present and unique with valid format
- Password must be at least 8 characters
- Password confirmation must match password

### 3. Mailer Layer
**File**: `app/mailers/users/user_mailer.rb`
- Custom mailer inheriting from ApplicationMailer
- Sends confirmation instructions, password reset, and unlock emails
- Generates secure confirmation URLs with tokens

**Email Templates**:
- `app/views/users/user_mailer/confirmation_instructions.html.erb` - HTML version
- `app/views/users/user_mailer/confirmation_instructions.text.erb` - Text version

### 4. Controller Layer
**Files**:
- `app/controllers/users/registrations_controller.rb` - Handles sign up form submission
- `app/controllers/users/confirmations_controller.rb` - Handles email confirmation

**Key Responsibilities**:
- `RegistrationsController#create` - Creates new user and sends confirmation email
- `ConfirmationsController#show` - Confirms user account via token

### 5. View Layer
**Files**:
- `app/views/devise/registrations/new.html.erb` - Sign up form with validation feedback
- `app/views/confirmations/pending.html.erb` - Confirmation pending page

**Design**:
- Built with Tailwind CSS and DaisyUI components
- Responsive and mobile-friendly
- Clear error messaging and user guidance

### 6. Configuration
**Files**:
- `config/initializers/devise.rb` - Devise configuration settings
- `config/environments/development.rb` - Development mailer settings
- `config/environments/production.rb` - Production SMTP configuration
- `config/routes.rb` - Custom controller routes

**Key Settings**:
- Confirmation token expiration: 3 days
- Custom mailer: Users::UserMailer
- Email validations enabled

## User Flow

### Sign Up Flow
1. User navigates to `/users/sign_up`
2. Fills in email, password, and password confirmation
3. Form validates on both client and server side
4. System creates user with unconfirmed status
5. Sends confirmation email to user's email address
6. User is redirected to confirmation pending page

### Email Confirmation Flow
1. User receives confirmation email with secure link
2. Clicks link in email
3. System validates confirmation token (must be within 3 days)
4. User account is marked as confirmed
5. User is automatically logged in
6. User is redirected to home page

## Features

### Security
- Passwords hashed with bcrypt
- Confirmation tokens are cryptographically secure
- Email validation with format checking
- CSRF protection enabled
- SQL injection prevention via Active Record

### User Experience
- Clear error messages for validation failures
- Responsive design for all devices
- Email resend capability
- Confirmation token expiration handling
- Helpful guidance on confirmation pending page

### Email Features
- HTML and text versions of emails
- Personalized confirmation messages
- Environment-aware URLs (localhost/production)
- Configurable sender email and SMTP settings

## Environment Variables

### Development
- Uses test delivery method by default (emails in ActionMailer::Base.deliveries)
- Can be changed to `:letter_opener` for browser preview

### Production
```env
APP_HOST=wabotalk.com
MAIL_FROM=noreply@wabotalk.com
SMTP_USERNAME=your_smtp_user
SMTP_PASSWORD=your_smtp_password
SMTP_ADDRESS=smtp.example.com
SMTP_PORT=587
```

## Testing

**Test File**: `test/models/user_test.rb`

**Test Coverage**:
- Email presence and format validation
- Password strength validation
- Duplicate email prevention
- Confirmation token generation
- Email confirmation process
- Devise notification queuing

**Run Tests**:
```bash
rails test test/models/user_test.rb
```

## Setup Instructions

### 1. Run Migrations
```bash
rails db:migrate
```

### 2. Set Environment Variables
Create `.env` file or add to your Rails credentials:
```bash
rails credentials:edit
```

### 3. Test Locally
```bash
rails s
# Visit http://localhost:3000/users/sign_up
```

### 4. Configure SMTP for Production
Update production SMTP settings in credentials or environment variables

## Files Modified/Created

### Created
- `db/migrate/20260218030000_add_confirmable_to_users.rb`
- `app/controllers/users/registrations_controller.rb`
- `app/controllers/users/confirmations_controller.rb`
- `app/mailers/users/user_mailer.rb`
- `app/views/users/user_mailer/confirmation_instructions.html.erb`
- `app/views/users/user_mailer/confirmation_instructions.text.erb`
- `app/views/devise/registrations/new.html.erb`
- `app/views/confirmations/pending.html.erb`
- `DOCUMENTS/US-1.1-IMPLEMENTATION.md`

### Modified
- `app/models/user.rb`
- `config/initializers/devise.rb`
- `config/routes.rb`
- `config/environments/development.rb`
- `config/environments/production.rb`
- `test/models/user_test.rb`

## Git Commit Message
```
[US-1.1] Implement Device Authentication - Sign Up

- Add :confirmable module to User model
- Create custom RegistrationsController for sign up
- Create custom ConfirmationsController for email verification
- Implement Users::UserMailer for confirmation emails
- Create responsive sign up form with email and password validation
- Add confirmation pending page with resend instructions
- Configure Devise for email confirmation workflow (3-day expiration)
- Add comprehensive test coverage for User model validations
- Update development and production mailer configurations
- Setup environment variables for SMTP configuration
```

## Next Steps
1. Test thoroughly in development environment
2. Configure SMTP details for staging/production
3. Implement additional features from Phase 2 (US-1.2, US-1.3, US-1.4)
4. Set up email templates customization and localization

## References
- [Devise Documentation](https://github.com/heartcombo/devise)
- [Rails Email Guide](https://guides.rubyonrails.org/action_mailer_basics.html)
- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
