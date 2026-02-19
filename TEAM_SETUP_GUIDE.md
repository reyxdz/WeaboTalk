# 🎬 WeaboTalk Team Development Setup Guide

## Prerequisites (Do Once)

Each team member needs to install these on their computer:

### 1. **PostgreSQL** (Database)
- Download: https://www.postgresql.org/download/windows/
- Choose version 14 or higher
- **During installation:**
  - Choose a password (e.g., `password123`)
  - Remember this password - you'll use it later
  - Default port: 5432

### 2. **Ruby** (Language)
- Download: https://rubyinstaller.org/
- Choose Ruby 3.2 or higher with DevKit
- Install with default settings

### 3. **Node.js** (JavaScript runtime)
- Download: https://nodejs.org/
- Choose LTS version
- Install with default settings

### 4. **Git** (Version control)
- Download: https://git-scm.com/download/win
- Install with default settings

---

## Initial Setup (First Time Only)

### Step 1: Clone the Repository
```powershell
# Navigate to where you want the project
cd "C:\Your Projects"

# Clone the WeaboTalk repository
git clone https://github.com/reyxdz/WeaboTalk.git
cd WeaboTalk
```

### Step 2: Install Ruby Dependencies
```powershell
bundle install
```
*This takes 2-5 minutes the first time*

### Step 3: Install Node.js Dependencies
```powershell
npm install
```

### Step 4: Create Your Local Database
```powershell
# Replace 'your_postgres_password' with the password you set during PostgreSQL installation
$env:POSTGRES_PASSWORD = "your_postgres_password"

# Create the database
rails db:create

# Run migrations (set up tables)
rails db:migrate

# Optional: Add sample data
rails db:seed
```

✅ **You're all set!** Your local environment is ready.

---

## Running the Project (Every Time You Code)

### Terminal 1: Start the Rails Server
```powershell
cd "C:\Your Projects\WeaboTalk"
$env:POSTGRES_PASSWORD = "your_postgres_password"
rails server -p 3000
```

Output should show:
```
=> Rails 7.x.x application starting in development
=> Run `rails server --help` for more startup options
Puma starting in single mode...
* Listening on http://127.0.0.1:3000
```

**Then open your browser:** http://localhost:3000

### Terminal 2: Watch for CSS Changes (Tailwind)
In a **new PowerShell window**, run:
```powershell
cd "C:\Your Projects\WeaboTalk"
bin/rails tailwindcss:watch
```

Output should show:
```
Watching for changes...
```

→ This auto-compiles your Tailwind/DaisyUI changes as you edit files

**Keep both terminals open while developing!**

---

## Working with Git & Features

### When Starting Work on a New Feature

```powershell
# 1. Get latest code from main
git fetch origin
git pull origin main

# 2. Create your feature branch
git checkout -b feature/your-feature-name
```

**Feature branch naming examples:**
- `feature/user-authentication`
- `feature/anime-recommendation-feed`
- `feature/profile-page`
- `bugfix/notification-duplicate`

### Making & Pushing Changes

```powershell
# 1. After making changes, check status
git status

# 2. Stage your changes
git add .

# 3. Commit with clear message
git commit -m "Add user authentication feature

- Implemented login/signup with Devise
- Added password reset functionality
- Updated database migrations"

# 4. Push to GitHub
git push origin feature/your-feature-name
```

### Creating a Pull Request

1. Go to https://github.com/reyxdz/WeaboTalk
2. You'll see a "Compare & pull request" button
3. Click it and add a description
4. **Assign me (the leader) as the reviewer**
5. Click "Create pull request"

**Then wait for code review & approval before merging to `main`**

---

## Handling Updates & Styling

### When Tailwind Classes Change

If you're working on styling and Tailwind isn't updating:

```powershell
# Stop the tailwindcss:watch process (Ctrl+C)
# Then restart it
bin/rails tailwindcss:watch
```

### When DaisyUI Components Need Updating

DaisyUI is already configured. To check/update:

```powershell
# View DaisyUI version
npm list daisyui

# Update to latest
npm install daisyui@latest
```

Refer to: [DaisyUI Docs](https://daisyui.com/)

### When Someone Updates Dependencies

If the team updates gems or npm packages:

```powershell
# Update Ruby gems
bundle install

# Update Node packages
npm install

# Run any new database migrations
$env:POSTGRES_PASSWORD = "your_postgres_password"
rails db:migrate
```

---

## Common Commands Reference

| Task | Command |
|------|---------|
| **Start server** | `rails server -p 3000` |
| **Watch Tailwind** | `bin/rails tailwindcss:watch` |
| **Create database** | `rails db:create` |
| **Run migrations** | `rails db:migrate` |
| **Seed sample data** | `rails db:seed` |
| **Rails console** | `rails console` |
| **Check database tables** | `rails db` |
| **Clear cache** | `rails tmp:cache:clear` |
| **Restart after crashes** | `rails server -p 3000` |

---

## Fixing Common Issues

### "Error: Could not find PostgreSQL"
- Make sure PostgreSQL is installed and running
- On Windows, use Services app to start PostgreSQL service
- Check: `psql -U postgres -c "SELECT version();"`

### "Yarn not installed" or Missing dependencies
```powershell
npm install
bundle install
```

### Database errors after pulling latest code
```powershell
$env:POSTGRES_PASSWORD = "your_postgres_password"
rails db:migrate
```

### Port 3000 already in use
```powershell
# Kill existing Rails process
Get-Process -Name "ruby" -ErrorAction SilentlyContinue | Stop-Process -Force
# Wait 2 seconds
Start-Sleep -Seconds 2
# Restart server
rails server -p 3000
```

### CSS/Tailwind not applying
```powershell
# Ensure tailwindcss:watch is running in Terminal 2
# If not, kill and restart:
bin/rails tailwindcss:watch
```

---

## Code Review Checklist (Things I'll Check)

✅ Code follows Rails conventions  
✅ No console errors or warnings  
✅ Database migrations are included  
✅ Styling works on mobile/desktop  
✅ No duplicate code  
✅ Clear commit messages  
✅ Tests pass (if applicable)  

---

## Branch Protection Rules (Production Safety)

⚠️ **These are enforced on GitHub:**

- ❌ Cannot push directly to `main`
- ✅ Must create Pull Request
- ✅ Requires code review approval (from me)
- ✅ Must pass status checks (if enabled)
- ✅ Prevents accidental production breakage

---

## Quick Start Summary

```powershell
# First time setup
git clone https://github.com/reyxdz/WeaboTalk.git
cd WeaboTalk
bundle install
npm install
$env:POSTGRES_PASSWORD = "your_password"
rails db:create
rails db:migrate

# Every time you code
$env:POSTGRES_PASSWORD = "your_password"
rails server -p 3000

# In another terminal
bin/rails tailwindcss:watch

# Visit http://localhost:3000
```

---

## Questions?

Ask in the team chat or check the [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for architecture details.

Happy coding! 🚀
