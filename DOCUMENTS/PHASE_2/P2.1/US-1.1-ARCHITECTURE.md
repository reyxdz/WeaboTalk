# US-1.1: Architecture Diagram & Flow

## User Sign-Up Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                          USER BROWSER                           │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
            ┌────────────────────────────┐
            │  Sign-Up Form              │
            │  /users/sign_up            │
            │  GET request               │
            │  (new.html.erb)            │
            └────────────────┬───────────┘
                             │
                             │ User fills form & submits
                             ▼
            ┌────────────────────────────────────────┐
            │  Validation (Client-Side)              │
            │  - Required fields                     │
            │  - Email format                        │
            │  - Password length (8+)                │
            │  - Password confirmation               │
            └────────────────┬───────────────────────┘
                             │
                             ▼
            ┌────────────────────────────────────────┐
            │  POST /users (registrations#create)    │
            │  Send form data to server              │
            └────────────────┬───────────────────────┘
                             │
                             ▼
    ┌────────────────────────────────────────────────┐
    │     RAILS APPLICATION SERVER                  │
    │                                                │
    │  ┌──────────────────────────────────────────┐ │
    │  │ RegistrationsController#create            │ │
    │  │ - Validates email & password (server)     │ │
    │  │ - Checks for duplicates                   │ │
    │  │ - Creates User with :confirmable          │ │
    │  └──────┬───────────────────────────────────┘ │
    │         │                                      │
    │         ▼                                      │
    │  ┌──────────────────────────────────────────┐ │
    │  │ User Model                                │ │
    │  │ - Encrypt password                        │ │
    │  │ - Generate confirmation_token             │ │
    │  │ - Set confirmation_sent_at                │ │
    │  │ - Save to database                        │ │
    │  └──────┬───────────────────────────────────┘ │
    │         │                                      │
    │         ▼                                      │
    │  ┌──────────────────────────────────────────┐ │
    │  │ Devise#send_confirmation_instructions    │ │
    │  │ Triggers send_devise_notification hook   │ │
    │  └──────┬───────────────────────────────────┘ │
    │         │                                      │
    │         ▼                                      │
    │  ┌──────────────────────────────────────────┐ │
    │  │ Users::UserMailer#confirmation_           │ │
    │  │    instructions                           │ │
    │  │ - Build confirmation URL with token      │ │
    │  │ - Render HTML template                   │ │
    │  │ - Render text template                   │ │
    │  │ - Queue for delivery                     │ │
    │  └──────┬───────────────────────────────────┘ │
    │         │                                      │
    │         ▼                                      │
    │  ┌──────────────────────────────────────────┐ │
    │  │ ActionMailer (Development: test method)  │ │
    │  │ Stores email in memory for testing       │ │
    │  │ (Production: sends via SMTP)             │ │
    │  └──────┬───────────────────────────────────┘ │
    │         │                                      │
    └─────────┼──────────────────────────────────────┘
              │
              ▼
    ┌────────────────────────────────────────┐
    │  PostgreSQL Database                  │
    │                                        │
    │  users table:                          │
    │  - id: integer                         │
    │  - email: string (indexed, unique)     │
    │  - encrypted_password: string          │
    │  - confirmation_token: string (indexed)│
    │  - confirmed_at: datetime (null)       │
    │  - confirmation_sent_at: datetime      │
    │  - created_at: datetime                │
    │                                        │
    └────────────────────────────────────────┘
              │
              ▼
    ┌────────────────────────────────────────┐
    │  Email Service                         │
    │                                        │
    │  Development: ActionMailer             │
    │  (emails in memory)                    │
    │                                        │
    │  Production: SMTP                      │
    │  (sends to user inbox)                 │
    │                                        │
    └────────────────────────────────────────┘
              │
              ▼
    ┌────────────────────────────────────────┐
    │  User's Email Inbox                    │
    │                                        │
    │  Subject: Welcome to WeaboTalk!        │
    │  Please confirm your email             │
    │  address                               │
    │                                        │
    │  Body:                                 │
    │  [Confirm your email button/link]      │
    │  Link: /users/confirmation?            │
    │        confirmation_token=XXX          │
    │                                        │
    └────────────────────────────────────────┘
              │
              ▼ User clicks confirmation link
┌─────────────────────────────────────────────────────────────────┐
│                      USER BROWSER                               │
│  Request: GET /users/confirmation?confirmation_token=XXX        │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ▼
    ┌────────────────────────────────────────────┐
    │  RAILS APPLICATION SERVER                 │
    │                                            │
    │  ┌──────────────────────────────────────┐ │
    │  │ ConfirmationsController#show         │ │
    │  │ - Extract token from params          │ │
    │  │ - Find user by token                 │ │
    │  │ - Verify token not expired           │ │
    │  └──────┬───────────────────────────────┘ │
    │         │                                  │
    │         ▼                                  │
    │  ┌──────────────────────────────────────┐ │
    │  │ User#confirm_by_token (Devise)       │ │
    │  │ - Check token validity               │ │
    │  │ - Check token expiration (3 days)    │ │
    │  │ - Set confirmed_at to current time   │ │
    │  │ - Save user to database              │ │
    │  └──────┬───────────────────────────────┘ │
    │         │                                  │
    │         ▼                                  │
    │  ┌──────────────────────────────────────┐ │
    │  │ Auto-login User                      │ │
    │  │ - Sign in user automatically         │ │
    │  │ - Create session cookie              │ │
    │  │ - Set current_user                   │ │
    │  └──────┬───────────────────────────────┘ │
    │         │                                  │
    │         ▼                                  │
    │  ┌──────────────────────────────────────┐ │
    │  │ Redirect to root_path                │ │
    │  │ Flash: "Your email has been         │ │
    │  │         confirmed"                   │ │
    │  └──────┬───────────────────────────────┘ │
    │         │                                  │
    └─────────┼──────────────────────────────────┘
              │
              ▼
    ┌────────────────────────────────────────┐
    │  Home Page                             │
    │  User is logged in!                    │
    │  confirmed_at is set                   │
    │  Account is now active                 │
    └────────────────────────────────────────┘
```

## Project Structure

```
app/
├── controllers/
│   └── users/                                 [NEW]
│       ├── registrations_controller.rb        [NEW]
│       └── confirmations_controller.rb        [NEW]
├── mailers/
│   ├── application_mailer.rb                  [MODIFIED]
│   └── users/                                 [NEW]
│       └── user_mailer.rb                     [NEW]
├── models/
│   └── user.rb                                [MODIFIED]
└── views/
    ├── devise/
    │   └── registrations/
    │       └── new.html.erb                   [NEW]
    └── confirmations/                         [NEW]
        └── pending.html.erb                   [NEW]

config/
├── initializers/
│   └── devise.rb                              [MODIFIED]
├── environments/
│   ├── development.rb                         [MODIFIED]
│   └── production.rb                          [MODIFIED]
└── routes.rb                                  [MODIFIED]

db/
└── migrate/
    └── 20260218030000_add_confirmable_to_users.rb  [NEW]

test/
└── models/
    └── user_test.rb                           [MODIFIED]

DOCUMENTS/
├── US-1.1-IMPLEMENTATION.md                   [NEW]
├── US-1.1-SETUP-GUIDE.md                      [NEW]
├── US-1.1-COMPLETION-SUMMARY.md               [NEW]
├── US-1.1-TESTING-CHECKLIST.md                [NEW]
└── PROJECT_MANAGEMENT.md                      [MODIFIED]
```

## Data Model

```
┌─────────────────────────────────────────────────────────┐
│ users (PostgreSQL)                                      │
├─────────────────────────────────────────────────────────┤
│ id                    | integer PRIMARY KEY             │
│ email                 | string NOT NULL (UNIQUE INDEX)  │
│ encrypted_password    | string NOT NULL                 │
│ confirmation_token    | string (UNIQUE INDEX) [NEW]     │
│ confirmed_at          | datetime [NEW]                  │
│ confirmation_sent_at  | datetime [NEW]                  │
│ unconfirmed_email     | string [NEW]                    │
│ reset_password_token  | string                          │
│ reset_password_sent_at| datetime                        │
│ remember_created_at   | datetime                        │
│ created_at            | datetime NOT NULL               │
│ updated_at            | datetime NOT NULL               │
└─────────────────────────────────────────────────────────┘

STATE TRANSITIONS:

┌──────────────────────────────────────────────────────────────┐
│ User Confirmation State Machine                              │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  CREATE USER                                                 │
│      ↓                                                        │
│  ┌─────────────────┐                                          │
│  │ UNCONFIRMED     │  confirmed_at = nil                     │
│  │ STATE           │  confirmation_token = generated         │
│  └────────┬────────┘  confirmation_sent_at = now             │
│           │                                                   │
│           │ Send confirmation email                          │
│           │                                                   │
│           │ User clicks confirmation link                    │
│           ▼                                                   │
│  ┌─────────────────┐                                          │
│  │ CONFIRMED       │  confirmed_at = now                     │
│  │ STATE           │  User can log in                        │
│  └─────────────────┘  User is auto-logged in                 │
│                                                               │
│  If token expires (3 days):                                  │
│      ↓                                                        │
│  ┌─────────────────┐                                          │
│  │ EXPIRED         │  Token can no longer be used            │
│  │ TOKEN           │  User can request new token             │
│  └─────────────────┘                                          │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

## Request/Response Flow

```
CLIENT SIDE                    SERVER SIDE
───────────────────────────────────────────────

GET /users/sign_up        ──→  #new
                          ←──  HTML form
                               (new.html.erb)

POST /users/registrations ──→  #create
(email, password, pwd_conf)    │
                               ├→ Validations
                               ├→ Create User
                               ├→ Generate token
                               ├→ Send email
                               │
                          ←──  Redirect to
                               confirmation_pending

GET /users/confirmation   ──→  #show
?confirmation_token=XXX        │
                               ├→ Find user by token
                               ├→ Validate token
                               ├→ Set confirmed_at
                               ├→ Auto-login
                               │
                          ←──  Redirect & Flash
                               Sign-up complete!
```

## Key Components

### 1. Controller Layer
```
app/controllers/users/
├── registrations_controller.rb
│   ├── new     ← Load sign-up form
│   ├── create  ← Process sign-up submission
│   └── ...autres méthodes Devise
│
└── confirmations_controller.rb
    ├── create  ← Resend confirmation email
    └── show    ← Confirm email address
```

### 2. Mailer Layer
```
app/mailers/users/user_mailer.rb
├── confirmation_instructions
│   ├── Generate confirmation URL
│   ├── Render HTML template
│   ├── Render text template
│   └── Deliver
└── (reset_password_instructions, unlock_instructions)
```

### 3. Model Layer
```
app/models/user.rb
├── Associations (none for US-1.1)
├── Validations
│   ├── email presence, uniqueness, format
│   ├── password presence, length
│   └── password_confirmation presence, match
├── Devise modules
│   ├── :database_authenticatable
│   ├── :registerable
│   ├── :recoverable
│   ├── :rememberable
│   ├── :validatable
│   └── :confirmable
└── Custom methods
    ├── send_devise_notification
    └── devise_mailer
```

### 4. View Layer
```
app/views/
├── devise/registrations/new.html.erb
│   ├── Email input
│   ├── Password input
│   ├── Password confirmation input
│   ├── Error messages
│   └── Submit button
│
└── confirmations/pending.html.erb
    ├── Confirmation instructions
    ├── Email display
    ├── Resend link
    └── Home link
```

## Dependencies & Integration

```
┌──────────────────────────────────────────────────────┐
│ Gemfile Dependencies                                 │
├──────────────────────────────────────────────────────┤
│ ✅ devise              - Authentication & emails     │
│ ✅ rails               - Web framework               │
│ ✅ pg                  - PostgreSQL adapter          │
│ ✅ tailwindcss-rails   - CSS styling                 │
│ ✅ bcrypt              - Password hashing (implicit) │
│ ✅ activejob           - Background jobs             │
│ ✅ actionmailer        - Email delivery              │
└──────────────────────────────────────────────────────┘
```

---

This architecture ensures:
✅ Clean separation of concerns
✅ Security best practices
✅ Scalability for future features
✅ Easy testing and maintenance
✅ Professional user experience
