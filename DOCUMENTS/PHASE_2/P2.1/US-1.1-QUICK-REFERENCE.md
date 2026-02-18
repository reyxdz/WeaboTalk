# US-1.1 Quick Reference Guide

## ⚡ Quick Start Commands

### Setup
```bash
# Start PostgreSQL
Start-Service postgresql-x64-16

# Create & migrate database
rails db:create
rails db:migrate

# Run tests
rails test test/models/user_test.rb -v

# Start server
rails s
```

### Testing Locally
```
1. Open: http://localhost:3000/users/sign_up
2. Enter: email + password (8+ chars)
3. Click: Create Account
4. See: Confirmation pending page
5. Check: Rails console for email
   - rails c
   - ActionMailer::Base.deliveries.last
```

## 🏗️ Project Structure

```
Sign-Up Flow:
  /users/sign_up → registrations#new → registrations#create
  
Confirmation Flow:
  Email → confirmation link → confirmations#show → auto-login
  
Database:
  users table + confirmation fields (confirmation_token, confirmed_at)
  
Mailer:
  Users::UserMailer → confirmation_instructions
```

## 📝 Key Files

| File | Purpose | Change |
|------|---------|--------|
| `app/models/user.rb` | User model | ✏️ Modified |
| `app/controllers/users/registrations_controller.rb` | Sign-up | 🆕 New |
| `app/controllers/users/confirmations_controller.rb` | Email verification | 🆕 New |
| `app/mailers/users/user_mailer.rb` | Email sending | 🆕 New |
| `app/views/devise/registrations/new.html.erb` | Sign-up form | 🆕 New |
| `db/migrate/20260218030000_add_confirmable_to_users.rb` | Schema | 🆕 New |
| `config/initializers/devise.rb` | Configuration | ✏️ Modified |
| `config/routes.rb` | Routes | ✏️ Modified |

## 🔐 Security Features

```
✅ Bcrypt password hashing
✅ Secure token generation (40+ chars)
✅ Token expiration (3 days)
✅ Email format validation
✅ CSRF protection
✅ SQL injection prevention
✅ Password strength (8+ chars)
```

## 🧪 Tests

```bash
# Run all User tests
rails test test/models/user_test.rb -v

# Run specific test
rails test test/models/user_test.rb:UserTest#test_should_save_valid_user

# 16 test cases covering:
# - Email validation
# - Password validation
# - Confirmation token generation
# - Email confirmation process
# - Devise notifications
```

## 📧 Email Templates

**Confirmation Email**:
- Subject: "Welcome to WeaboTalk! Please confirm your email"
- Contains: Confirmation link + token
- Expires: 3 days
- Formats: HTML & Text

**Template Files**:
- `app/views/users/user_mailer/confirmation_instructions.html.erb`
- `app/views/users/user_mailer/confirmation_instructions.text.erb`

## ⚙️ Configuration

**Development**:
```ruby
config.action_mailer.delivery_method = :test
# Emails stored in ActionMailer::Base.deliveries
```

**Production**:
```env
APP_HOST=wabotalk.com
MAIL_FROM=noreply@wabotalk.com
SMTP_USERNAME=your_email
SMTP_PASSWORD=your_password
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
```

## 🐛 Debugging

### Check Sent Emails (Development)
```ruby
rails c
ActionMailer::Base.deliveries
ActionMailer::Base.deliveries.last
ActionMailer::Base.deliveries.last.body.encoded

# Get confirmation link
user = User.last
user.confirmation_token
# Visit: http://localhost:3000/users/confirmation?confirmation_token=TOKEN
```

### Check User Status
```ruby
user = User.find_by(email: 'test@example.com')
user.confirmed?           # true/false
user.confirmed_at         # timestamp or nil
user.confirmation_token   # secure token
user.encrypted_password   # hashed password
```

### Reset User Confirmation (Testing)
```ruby
user = User.last
user.update(confirmed_at: nil)  # Unconfirm
user.resend_confirmation_instructions  # Resend email
```

## 📋 Validation Rules

| Field | Rules | Error Message |
|-------|-------|---------------|
| Email | Required, Unique, Valid format | "can't be blank" / "has already been taken" / "is invalid" |
| Password | Required, Min 8 chars | "can't be blank" / "is too short" |
| Password Confirm | Required, Match password | "can't be blank" / "doesn't match" |

## 🎨 Form Design

**Framework**: Tailwind CSS + DaisyUI
**Responsive**: Mobile, Tablet, Desktop
**Colors**: Blue/Indigo theme
**Components**: Input, Button, Alert, Label

## 📱 API Endpoints

```
GET  /users/sign_up              → Sign-up form
POST /users                      → Create user
GET  /users/confirmation         → Confirm email
POST /users/confirmation         → Resend confirmation
POST /users/sign_in              → Sign in (US-1.2)
DELETE /users/sign_out           → Sign out (US-1.2)
```

## 🔄 User States

```
CREATE → UNCONFIRMED (confirmed_at = nil)
         ↓ Email confirmation
       CONFIRMED (confirmed_at = timestamp)
```

## ✅ Before Deploying

- [ ] PostgreSQL installed
- [ ] Database migrated
- [ ] Tests passing
- [ ] Email template verified
- [ ] SMTP configured (production)
- [ ] Environment variables set
- [ ] Code reviewed
- [ ] Documentation updated

## 📚 Full Documentation

- `US-1.1-IMPLEMENTATION.md` - Technical deep-dive
- `US-1.1-SETUP-GUIDE.md` - Setup instructions
- `US-1.1-TESTING-CHECKLIST.md` - Test cases
- `US-1.1-ARCHITECTURE.md` - Visual diagrams
- `US-1.1-NEXT-STEPS.md` - Deployment guide

## 🚀 Quick Deployment Checklist

```bash
# 1. Verify tests pass
rails test test/models/user_test.rb -v

# 2. Run migrations
rails db:migrate

# 3. Test locally
rails s
# Visit http://localhost:3000/users/sign_up

# 4. Commit code
git add -A
git commit -m "[US-1.1] Implement Device Authentication - Sign Up"
git push origin main

# 5. Deploy (follow deployment guide)
```

## 🆘 Common Issues

| Issue | Solution |
|-------|----------|
| "connection refused" on port 5432 | Start PostgreSQL: `Start-Service postgresql-x64-16` |
| "database does not exist" | Run: `rails db:create` |
| Tests failing | Run: `rails test test/models/user_test.rb -v` |
| Email not sending | Check ActionMailer::Base.deliveries in console |
| Confirmation link not working | Token might be expired (3 days) or invalid |

## 📞 Support

1. Check documentation files
2. Review test cases for examples
3. Check Rails logs: `log/development.log`
4. Use Rails console: `rails c`

---

**Last Updated**: February 18, 2026
**Status**: ✅ Ready for Testing
**Next Feature**: US-1.2 - Login/Logout
