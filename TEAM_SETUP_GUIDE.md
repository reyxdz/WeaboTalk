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

## Getting the Code: Clone the Repository

### **What is Cloning?**

Cloning downloads the entire project from GitHub to your computer, including all the code, git history, and branches.

### **Step 0: Choose a Location**

First, decide where on your computer you want the project:

```powershell
# Example locations:
cd "C:\Projects"
# or
cd "D:\Development"
# or
cd "$env:USERPROFILE\Projects"  # Home folder

# Then list what's there to confirm
ls
```

### **Step 1: Generate GitHub SSH Key (First Time Only)**

**SSH is more secure than HTTPS** - do this once per computer.

```powershell
# Generate a key (replace email with yours)
ssh-keygen -t ed25519 -C "your.email@gmail.com"

# When prompted to save the key, just press Enter (default location)
# When prompted for passphrase, press Enter (or set a password)
```

**Add the key to GitHub:**

```powershell
# Copy your public key
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | Set-Clipboard
```

Then:
1. Go to https://github.com/settings/keys
2. Click **"New SSH key"**
3. Paste the key (Ctrl+V)
4. Name it: "My Laptop" or "Work Computer"
5. Click **"Add SSH key"**

**Test the connection:**
```powershell
ssh -T git@github.com
# Should show: "Hi [username]! You've successfully authenticated..."
```

✅ Now you never have to enter GitHub password again!

### **Step 2: Clone the Repository**

Using SSH (recommended - no password needed):
```powershell
git clone git@github.com:reyxdz/WeaboTalk.git
cd WeaboTalk
```

Or using HTTPS (will ask for password each time):
```powershell
git clone https://github.com/reyxdz/WeaboTalk.git
cd WeaboTalk
```

### **Step 3: Verify You Have the Latest Code**

```powershell
# Check current branch (should be main)
git branch

# See the last 5 commits
git log --oneline -5

# Get latest updates from GitHub
git fetch origin

# Check status
git status
# Should show: "On branch main, Your branch is up to date with 'origin/main'"
```

---

## Initial Setup (First Time Only)

### Step 1: Install Ruby Dependencies

In your WeaboTalk project folder:
```powershell
bundle install
```
*This takes 2-5 minutes the first time*

### Step 2: Install Node.js Dependencies
```powershell
npm install
```

### Step 3: Create Your Local Database
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

✅ **Important:** This pushes to `feature/your-feature-name`, NOT to `main`!

### Creating a Pull Request

1. Go to https://github.com/reyxdz/WeaboTalk
2. You'll see a "Compare & pull request" button
3. Click it and add a description
4. **Assign me (the leader) as the reviewer**
5. Click "Create pull request"

**Then wait for code review & approval before merging to `main`**

---

## ⚠️ Protected Main Branch (Important!)

### **Your Code Does NOT Go Directly to Main**

When you push your feature branch, it's **completely separate** from the main branch:

```
Your Computer                GitHub                     Live Site
─────────────────────────────────────────────────────────────────
You push code  ──→  feature/your-feature  ✅ Safe!
(git push)          (Shows as PR)                  Main branch
                                                   stays protected
                Only leader can                    ↓
                merge to main                  Production code
```

### **Step-by-Step Protection**

1. **You push to your feature branch**
   ```powershell
   git push origin feature/anime-recommendations
   ```
   ✅ Code goes to GitHub, but **NOT to main**

2. **You create a Pull Request**
   - Code is ready for review
   - Leader gets notification

3. **Leader reviews your code**
   - Checks for bugs
   - Tests it locally
   - Approves or requests changes

4. **Leader merges to main**
   - Only after approval
   - Now it's in production

5. **Feature branch is deleted**
   - Clean history maintained

### **You Cannot Accidentally Break Main**

Even if you try to force push:
```powershell
# This will FAIL (don't worry, it's blocked!)
git push origin main

# Error: 🚫
# [rejected]  main -> main 
# (protected branch)
```

**Why?** Branch protection rules prevent:
- ❌ Direct pushes to main
- ❌ Merging without approval
- ❌ Code going live without review

### **The Safe Workflow**

```
Step 1: Create branch
├─ git checkout -b feature/your-feature

Step 2: Code & Commit
├─ Make changes
├─ git add .
├─ git commit -m "..."

Step 3: Push to GitHub
├─ git push origin feature/your-feature
├─ ✅ Safe! Goes to feature branch only

Step 4: Create Pull Request
├─ On GitHub
├─ ✅ Waiting for review (locked)

Step 5: Leader Reviews
├─ Tests your code
├─ Checks for issues
├─ Approves ✓

Step 6: Merge to Main
├─ Leader clicks "Merge"
├─ ✅ Now in production
└─ You & everyone pulls latest
```

### **What to Do When Your PR is Approved**

```powershell
# Nothing! Just pull the latest main when ready for next feature
git fetch origin
git pull origin main

# Then create new feature branch for next feature
git checkout -b feature/next-feature
```

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

### **Cloning Issues**

| Error | Solution |
|-------|----------|
| "Permission denied (publickey)" | SSH key not set up - use HTTPS cloning instead, or set up SSH (see Getting the Code section) |
| "Repository not found" | Check the URL: `https://github.com/reyxdz/WeaboTalk.git` |
| "Could not resolve host" | Check your internet connection |
| "Already exists" | Folder already there - delete it: `rm -Recurse WeaboTalk` and try again |
| "fatal: The remote end hung up unexpectedly" | Network issue - try cloning again |

### **Post-Clone Verification**

After cloning, verify everything is correct:

```powershell
# Make sure you're in the right folder
cd WeaboTalk
pwd  # Check current location shows WeaboTalk path

# Verify the repo is healthy
git status
# Should show: "On branch main, Your branch is up to date with 'origin/main'"

# Check git history
git log --oneline -1
# Should show the latest commit from GitHub

# List all files to confirm complete clone
ls -la
# Should show: app/, config/, db/, Gemfile, package.json, etc.
```

### **PostgreSQL Issues**

**Error: "Could not find PostgreSQL"**
- Make sure PostgreSQL is installed and running
- On Windows, use Services app to start PostgreSQL service
- Check: `psql -U postgres -c "SELECT version();"`

**Can't connect to database**
```powershell
# Verify PostgreSQL is running
Get-Service PostgreSQL* | Format-Table Name, Status

# If stopped, start it
Start-Service PostgreSQL14  # or your version
```

### **Dependency Issues**

**"Yarn not installed" or Missing dependencies**
```powershell
npm install
bundle install
```

**Database errors after pulling latest code**
```powershell
$env:POSTGRES_PASSWORD = "your_postgres_password"
rails db:migrate
```

### **Runtime Issues**

**Port 3000 already in use**
```powershell
# Kill existing Rails process
Get-Process -Name "ruby" -ErrorAction SilentlyContinue | Stop-Process -Force
# Wait 2 seconds
Start-Sleep -Seconds 2
# Restart server
rails server -p 3000
```

**CSS/Tailwind not applying**
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

### **First Time (One Computer - 10 minutes)**

```powershell
# 1. Set up GitHub SSH (do once per computer)
ssh-keygen -t ed25519 -C "your.email@gmail.com"
# Then add the key to GitHub: https://github.com/settings/keys

# 2. Clone the repository

# 2. Clone the repository
git clone git@github.com:reyxdz/WeaboTalk.git
cd WeaboTalk

# 3. Install everything
bundle install
npm install

# 4. Setup database
$env:POSTGRES_PASSWORD = "your_local_postgres_password"
rails db:create
rails db:migrate
rails db:seed  # Optional

# ✅ You're ready!
```
ssh-keygen -t ed25519 -C "your.email@gmail.com"

### **Every Time You Code (Start of Session)**

Terminal 1:
```powershell
cd WeaboTalk
$env:POSTGRES_PASSWORD = "your_local_postgres_password"
rails server -p 3000
```

Terminal 2:
```powershell
cd WeaboTalk
bin/rails tailwindcss:watch
```

Then open: http://localhost:3000

---

## Questions?

Ask in the team chat or check the [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for architecture details.

Happy coding! 🚀
