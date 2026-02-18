# US-1.1 Testing Checklist

Use this checklist to verify all aspects of the Sign Up implementation are working correctly.

## Pre-Testing Setup ✅

- [ ] PostgreSQL installed and running
- [ ] Database created: `rails db:create`
- [ ] Migrations executed: `rails db:migrate`
- [ ] Rails server started: `rails s`
- [ ] Browser opened to `http://localhost:3000`

## Sign-Up Form Tests ✅

### Form Rendering
- [ ] Sign-up form loads at `/users/sign_up`
- [ ] Page displays "WeaboTalk" branding
- [ ] Form has email input field
- [ ] Form has password input field
- [ ] Form has password confirmation input field
- [ ] Form has "Create Account" submit button
- [ ] Form displays link to sign-in page
- [ ] Form displays terms of service notice

### Form Styling
- [ ] Form is centered on the page
- [ ] Form has a clean, modern design
- [ ] Form is responsive (test on mobile)
- [ ] Input fields have proper styling
- [ ] Submit button is clearly visible
- [ ] Colors match branding (blue/indigo)

## Validation Tests ✅

### Email Validation
- [ ] Empty email shows error: "Email can't be blank"
- [ ] Invalid email (no @) shows error: "Email is invalid"
- [ ] Duplicate email shows error: "Email has already been taken"
- [ ] Valid email (user@example.com) is accepted

### Password Validation
- [ ] Empty password shows error: "Password can't be blank"
- [ ] Password < 8 characters shows error: "Password is too short"
- [ ] Valid password (8+ chars) is accepted

### Password Confirmation Validation
- [ ] Empty confirmation shows error: "Password confirmation can't be blank"
- [ ] Mismatched passwords show error: "Password confirmation doesn't match"
- [ ] Matching passwords are accepted

### Client-Side Validation
- [ ] Error messages appear below relevant fields
- [ ] Error messages are styled with red color
- [ ] Errors clear when field is corrected
- [ ] Form prevents submission with errors (attempt with empty form)

## User Creation Tests ✅

### Successful Sign-Up
- [ ] Submit form with valid email + password (min 8 chars)
- [ ] User should be created in database (check `rails c` > `User.last`)
- [ ] User email matches what was entered
- [ ] User confirmation_token is generated
- [ ] User confirmed_at is nil (not yet confirmed)
- [ ] Page redirects to confirmation pending page

### Database Fields
- [ ] Check user record has:
  - [ ] email: correctly stored
  - [ ] encrypted_password: hashed (not plaintext)
  - [ ] confirmation_token: 43+ character string
  - [ ] confirmed_at: null/nil
  - [ ] confirmation_sent_at: timestamp from creation
  - [ ] created_at: current time

## Email Tests ✅

### Email Delivery (Development)
- [ ] Open Rails console: `rails c`
- [ ] Check emails: `ActionMailer::Base.deliveries`
- [ ] Last email should be confirmation email
- [ ] Email recipient is user's email address
- [ ] Email subject is "Welcome to WeaboTalk! Please confirm your email"

### Email Content
- [ ] HTML email includes "Welcome to WeaboTalk! 🎌"
- [ ] HTML email includes user's email address
- [ ] HTML email includes confirmation link
- [ ] HTML email includes helpful instructions
- [ ] HTML email includes expiration notice (3 days)
- [ ] Text version also has all content
- [ ] Confirmation URL looks valid and includes token

### Email Links
- [ ] Copy confirmation link from email
- [ ] Link format: `/users/confirmation?confirmation_token=XXX`
- [ ] Link includes secure token (long random string)
- [ ] Token matches user's confirmation_token in database

## Email Confirmation Tests ✅

### Via Confirmation Link
- [ ] Click confirmation link from email (in development logs)
- [ ] Page should confirm account and log user in
- [ ] User redirected to home page (root_path)
- [ ] Response message: "Your email address has been successfully confirmed"
- [ ] User record should have:
  - [ ] confirmed_at: populated with timestamp
  - [ ] confirmation_token: still stored
  - [ ] User is now logged in

### Invalid Token
- [ ] Try to access `/users/confirmation?confirmation_token=invalid`
- [ ] Page shows error message
- [ ] User is NOT logged in
- [ ] User account is NOT confirmed

### Expired Token
- [ ] In Rails console:
  ```ruby
  user = User.last
  user.update(confirmation_sent_at: 4.days.ago)
  # Try to confirm with old token
  user.confirm_by_token(user.confirmation_token)
  ```
- [ ] Confirmation fails (token expired)
- [ ] Error message indicates token has expired

## Confirmation Pending Page Tests ✅

### Page After Sign-Up
- [ ] After successful sign-up, see confirmation pending page
- [ ] Page displays "Check Your Email" heading
- [ ] Page shows email address (partially masked on real email)
- [ ] Page displays checkmark icon (✓)
- [ ] Page has helpful instructions

### Resend Functionality
- [ ] "Didn't receive an email?" link is present
- [ ] Clicking link redirects to resend confirmation
- [ ] Resend form allows entering email
- [ ] Resend triggers new confirmation email
- [ ] New confirmation email is sent (check ActionMailer::Base.deliveries)

### Navigation
- [ ] "Back to home" link works
- [ ] Clicking returns to home page
- [ ] Sign-in link goes to sign-in page

## Security Tests ✅

### SQL Injection Attempts
- [ ] Email field: `test@example.com' OR '1'='1`
- [ ] Should be safely escaped and rejected as invalid email

### Password Security
- [ ] Password is never shown in plain text in database
- [ ] Password is never logged in application logs
- [ ] encrypted_password field contains hash, not plaintext

### CSRF Protection
- [ ] Form includes hidden CSRF token field
- [ ] Submitting form without token fails
- [ ] Rails automatically handles CSRF protection

### Token Security
- [ ] confirmation_token is unique
- [ ] confirmation_token is long enough (40+ chars)
- [ ] confirmation_token is different for each user
- [ ] Token is only valid for 3 days

## Unit Tests ✅

### Run All Tests
```bash
rails test test/models/user_test.rb -v
```

Verify all tests pass:
- [ ] test_should_not_save_user_without_email
- [ ] test_should_not_save_user_with_invalid_email_format
- [ ] test_should_not_save_user_with_duplicate_email
- [ ] test_should_not_save_user_without_password_on_create
- [ ] test_should_not_save_user_with_password_shorter_than_8_characters
- [ ] test_should_not_save_user_with_mismatched_password_confirmation
- [ ] test_should_save_valid_user
- [ ] test_user_should_have_confirmation_token_after_creation
- [ ] test_user_should_not_be_confirmed_upon_creation
- [ ] test_user_should_be_able_to_get_confirmed
- [ ] test_send_devise_notification_should_queue_email
- [ ] test_email_should_be_case_insensitive
- [ ] test_should_not_save_user_with_whitespace_around_email

All tests should show: ✅ PASSED

## Browser Compatibility ✅

Test on multiple browsers:
- [ ] Chrome/Edge (desktop)
- [ ] Firefox (desktop)
- [ ] Safari (if available)
- [ ] Chrome (mobile)
- [ ] Safari (mobile)

Verify on each:
- [ ] Form layouts correctly
- [ ] All elements are visible
- [ ] Inputs are usable
- [ ] Error messages display
- [ ] Links work properly

## Edge Case Tests ✅

### Unique Email Scenarios
- [ ] Sign up with user1@example.com
- [ ] Attempt sign up with user1@example.com again
- [ ] Error displayed: "Email has already been taken"
- [ ] Try User1@Example.Com (different case)
- [ ] Correctly identified as duplicate (case-insensitive)

### Long Input Tests
- [ ] Email with 254 characters (max valid)
- [ ] Email with 255 characters (too long)
- [ ] Password with 100+ characters
- [ ] Verify all edge cases handled correctly

### Special Characters
- [ ] Email with + character: user+tag@example.com
- [ ] Email with . character: user.name@example.com
- [ ] Password with special chars: P@ssw0rd!#$%
- [ ] All should work correctly

## Performance Tests ✅

### Sign-Up Speed
- [ ] Form loads in < 1 second
- [ ] Form submit processes in < 2 seconds
- [ ] Email sending takes < 1 second (development)
- [ ] No N+1 database queries in sign-up

### Database
- [ ] User creation uses indexed email field
- [ ] Confirmation token lookup uses index
- [ ] No duplicate queries on form load

## Documentation Verification ✅

- [ ] US-1.1-IMPLEMENTATION.md is clear and complete
- [ ] US-1.1-SETUP-GUIDE.md has correct instructions
- [ ] README.md mentions authentication setup
- [ ] Code has helpful comments

## Known Limitations & Notes ✅

- [ ] Email delivery in development uses :test method (in memory)
- [ ] Production requires SMTP credentials configuration
- [ ] Confirmation token expires after 3 days
- [ ] Unconfirmed users cannot access the application

## Sign-Off Checklist ✅

### Development Team
- [ ] Code review completed
- [ ] All tests pass
- [ ] No console errors or warnings
- [ ] Documentation is complete
- [ ] Ready for staging deployment

### QA Testing Team
- [ ] All test cases above completed
- [ ] No critical bugs found
- [ ] User experience is smooth
- [ ] Performance is acceptable
- [ ] Security requirements met

### Deployment
- [ ] Database migrations ready
- [ ] Environment variables documented
- [ ] SMTP configuration complete
- [ ] Staging deployment successful
- [ ] Ready for production

---

## Final Verification

**Date Tested**: ________________
**Tested By**: ________________
**Status**: [ ] PASSED [ ] FAILED (note issues below)

**Issues Found**:
```
(List any bugs or issues)

1. Issue:
   Steps to reproduce:
   Expected:
   Actual:

2. Issue:
   ...
```

**Sign-Off**:
- [ ] All tests passed
- [ ] No critical issues
- [ ] Ready to proceed to US-1.2

**Approved By**: ________________ **Date**: ________________

---

**Total Test Cases**: 50+
**Estimated Time**: 1-2 hours
**Test Environment**: Local development with Rails server
