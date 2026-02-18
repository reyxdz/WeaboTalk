# US-1.1 Setup Guide: Database and Environment Configuration

## Prerequisites
Before implementing US-1.1, ensure you have the following installed:

### 1. PostgreSQL Installation

**Windows Installation**:
```
1. Download from https://www.postgresql.org/download/windows/
2. Run the installer and follow the setup wizard
3. Choose a password for the 'postgres' superuser
4. Use default port 5432
5. Install pgAdmin (optional, for graphical database management)
6. Add PostgreSQL bin directory to PATH environment variable
   - Typical path: C:\Program Files\PostgreSQL\16\bin
```

**Verify Installation**:
```powershell
psql --version
```

### 2. Start PostgreSQL Service

**Windows**:
```powershell
# Start PostgreSQL service
Start-Service postgresql-x64-16

# Or use:
net start postgresql-x64-16

# Stop service:
Stop-Service postgresql-x64-16
# Or: net stop postgresql-x64-16
```

**Check Service Status**:
```powershell
Get-Service postgresql-x64-16
```

## Running Migrations

Once PostgreSQL is running, execute these commands:

```bash
cd "c:\Personal Projects\WeaboTalk"

# Create the development database
rails db:create

# Run all pending migrations
rails db:migrate

# Verify schema
rails db:schema:load
```

## What Was Implemented in US-1.1

### Database Changes
- Added `confirmation_token` (string) - Secure token for email verification
- Added `confirmed_at` (datetime) - When user confirmed their email
- Added `confirmation_sent_at` (datetime) - When confirmation email was sent
- Added `unconfirmed_email` (string) - Temporary storage for email changes
- Added unique index on `confirmation_token`

### Code Structure

```
app/
├── controllers/
│   └── users/
│       ├── registrations_controller.rb      # Sign up form handling
│       └── confirmations_controller.rb      # Email verification
├── mailers/
│   └── users/
│       └── user_mailer.rb                   # Email sending
├── models/
│   └── user.rb                              # Updated with :confirmable
├── views/
│   ├── devise/
│   │   └── registrations/
│   │       └── new.html.erb                 # Sign up form
│   └── confirmations/
│       └── pending.html.erb                 # Confirmation pending page
config/
├── initializers/
│   └── devise.rb                            # Updated configuration
├── environments/
│   ├── development.rb                       # Dev mailer settings
│   └── production.rb                        # Prod SMTP settings
└── routes.rb                                # Custom controller routes
db/
└── migrate/
    └── 20260218030000_add_confirmable_to_users.rb
test/
└── models/
    └── user_test.rb                         # Comprehensive tests
```

### Key Features
✅ Email validation with format checking
✅ Password validation (minimum 8 characters)
✅ Confirmation token generation (3-day expiration)
✅ HTML and text email templates
✅ Responsive UI with Tailwind CSS
✅ Comprehensive error handling
✅ Full test coverage

## Testing Locally

### 1. Start the Rails Server
```bash
rails s
# Navigate to http://localhost:3000/users/sign_up
```

### 2. Run Tests
```bash
# Run all User model tests
rails test test/models/user_test.rb

# Run specific test
rails test test/models/user_test.rb:UserTest#test_should_save_valid_user

# Run with verbose output
rails test test/models/user_test.rb -v
```

### 3. Check Sent Emails (Development)
```ruby
# In Rails console
rails console

# View sent emails
ActionMailer::Base.deliveries.last
ActionMailer::Base.deliveries.last.body.encoded
```

## Email Configuration

### Development Environment
- Uses `:test` delivery method by default
- Emails stored in memory (ActionMailer::Base.deliveries)
- Can switch to `:letter_opener` for browser preview

### Production Environment
Environment variables needed:
```env
APP_HOST=www.wabotalk.com
MAIL_FROM=noreply@wabotalk.com
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_ADDRESS=smtp.gmail.com  (or your provider)
SMTP_PORT=587
```

## Common Issues & Solutions

### Issue: "database does not exist"
```bash
rails db:create
rails db:migrate
```

### Issue: "connection refused" on port 5432
```powershell
# Check if PostgreSQL service is running
Get-Service postgresql-x64-16

# Start PostgreSQL
Start-Service postgresql-x64-16
```

### Issue: "permission denied" for postgres user
```powershell
# Reset postgres password
psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'your_new_password';"

# Update config/database.yml if needed
```

### Issue: Emails not sending in production
1. Verify SMTP credentials
2. Check spam/promotions folder
3. Review SMTP logs: `log/production.log`
4. Whitelist sender domain in email provider

## Next Steps

1. **Database Setup**: 
   - Install PostgreSQL
   - Run migrations

2. **Server Testing**:
   - Start Rails server
   - Test sign up flow at /users/sign_up
   - Verify confirmation email process

3. **SMTP Configuration**:
   - Configure email provider (Gmail, SendGrid, etc.)
   - Set environment variables
   - Test email delivery

4. **Team Integration**:
   - Share credentials securely
   - Document email provider settings
   - Test email delivery in staging

5. **Continue to Phase 2**:
   - US-1.2: Login/Logout functionality
   - US-1.3: Password Recovery
   - US-1.4: User Profile Management

## Documentation Files

- `DOCUMENTS/US-1.1-IMPLEMENTATION.md` - Complete technical documentation
- `DOCUMENTS/POSTGRES_SETUP.md` - PostgreSQL setup guide
- `DOCUMENTS/SETUP_GUIDE.md` - Overall project setup
- `README.md` - Project overview

## Support & Resources

- [Rails Documentation](https://guides.rubyonrails.org/)
- [Devise Gem](https://github.com/heartcombo/devise)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Action Mailer](https://guides.rubyonrails.org/action_mailer_basics.html)
