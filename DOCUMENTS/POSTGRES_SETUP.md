# PostgreSQL Configuration Helper for WeaboTalk

## Windows PostgreSQL Setup

Your PostgreSQL is installed and running (version 16 and/or 18). Now we need to configure Rails to connect properly.

### Option 1: Use Environment Variable (Recommended)

Open PowerShell and set your PostgreSQL password, then run Rails commands:

```powershell
# Replace 'your_postgres_password' with your actual PostgreSQL password
$env:POSTGRES_PASSWORD="your_postgres_password"

# Then run Rails commands
rails db:create
rails db:migrate
```

### Option 2: Modify database.yml (Not Recommended - Security Risk)

Edit `config/database.yml` and replace:
```yaml
password: <%= ENV.fetch("POSTGRES_PASSWORD", "postgres") %>
```

With:
```yaml
password: your_actual_password
```

⚠️ WARNING: Never commit passwords to Git!

### Option 3: Find Your PostgreSQL Password

If you forgot your PostgreSQL password, you can reset it:

1. **Stop PostgreSQL Service**
   ```powershell
   Stop-Service postgresql-x64-16  # or postgresql-x64-18
   ```

2. **Start in No-Auth Mode** (Windows)
   - Edit PostgreSQL config file
   - Or rebuild with trust authentication

3. **Ask during Installation**
   - Uninstall PostgreSQL
   - Reinstall and remember the password you set for `postgres` user

### Option 4: Create New PostgreSQL User

If you can connect as postgres:

```sql
psql -U postgres -h 127.0.0.1

-- Enter password or press Enter if no password set

-- Create new user for development
CREATE USER weabo_talk WITH PASSWORD 'development_password';
ALTER USER weabo_talk CREATEDB;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE weabo_talk_development TO weabo_talk;
```

Then update database.yml:
```yaml
development:
  username: weabo_talk
  password: development_password
```

---

## Manual Connection Test

Try connecting with psql directly:

```powershell
psql -U postgres -h 127.0.0.1 -c "SELECT version();"
```

If prompted for password, enter your PostgreSQL password.
If it connects successfully, use that password in your setup.

---

## Complete Setup Steps

1. **Determine your PostgreSQL password**
   - Default is often: `postgres`
   - Or the password you set during installation
   - Or test with: `psql -U postgres -h 127.0.0.1`

2. **Set environment variable in PowerShell:**
   ```powershell
   $env:POSTGRES_PASSWORD="your_password_here"
   ```

3. **Create databases:**
   ```powershell
   cd "c:\Personal Projects\WeaboTalk"
   rails db:create
   ```

4. **Run migrations:**
   ```powershell
   rails db:migrate
   ```

5. **Start development server:**
   ```powershell
   ./bin/dev
   ```

---

## Common Issues

### "fe_sendauth: no password supplied"
→ PostgreSQL authentication failed. Check password.

### "server closed the connection unexpectedly"
→ PostgreSQL version mismatch or configuration issue. Try IPv4 (127.0.0.1) instead.

### "port already in use"
→ Another process using port 5432. Check `Get-NetTCPConnection -LocalPort 5432`

### Can't find psql
→ PostgreSQL bin directory not in PATH. Add it manually:
```powershell
$env:PATH += ";C:\Program Files\PostgreSQL\16\bin"
```

---

## Next Steps

Once you have your password:

1. Run: `$env:POSTGRES_PASSWORD="your_password"`
2. Run: `rails db:create`
3. Run: `rails db:migrate`
4. Run: `./bin/dev` to start the server

Let me know what output you get and I'll help troubleshoot!
