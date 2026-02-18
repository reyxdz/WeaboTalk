# Templates Directory

This directory contains code templates for the WeaboTalk project. These are reference implementations and structure guides for each team member.

## 📋 Contents

### Model Templates (Ruby)

- **user_template.rb** - User model with Devise authentication (MEMBER 1)
- **profile_template.rb** - User profile model (MEMBER 1)
- **post_template.rb** - Post model with content and images (MEMBER 2)
- **post_image_template.rb** - PostImage model for image attachments (MEMBER 2)
- **comment_template.rb** - Comment model with nested replies (MEMBER 3)
- **like_template.rb** - Like/favoriting system (MEMBER 3)
- **reaction_template.rb** - Emoji reactions on posts (MEMBER 3)
- **friendship_template.rb** - Friend request and relationship system (MEMBER 3)
- **notification_template.rb** - Real-time notification model (MEMBER 3)

## 🚀 How to Use

### For Model Creation

1. Open the relevant template file
2. Copy the code to your actual model file in `app/models/`
3. Customize as needed for your implementation
4. Add any additional validations or methods specific to your features

### Example

To create the User model:

```bash
# 1. Generate the model (Devise handles this automatically)
rails generate devise User

# 2. View TEMPLATES/user_template.rb for reference structure

# 3. Update app/models/user.rb based on template
```

## 📝 Template Structure

Each template includes:
- ✅ Attribute documentation
- ✅ Associations with other models
- ✅ Basic validations
- ✅ Scopes for common queries
- ✅ Callbacks (like after_create for notifications)
- ✅ TODO comments for implementation details
- ✅ References to user stories (US-X.X)

## 🎯 Team Mapping

| File | Member | User Stories |
|------|--------|--------------|
| user_template.rb | Member 1 | US-1.1, US-1.2, US-1.3 |
| profile_template.rb | Member 1 | US-1.4 |
| post_template.rb | Member 2 | US-2.1, US-2.2, US-2.3 |
| post_image_template.rb | Member 2 | US-2.2 |
| comment_template.rb | Member 3 | US-3.2 |
| like_template.rb | Member 3 | US-3.1 |
| reaction_template.rb | Member 3 | US-3.1 |
| friendship_template.rb | Member 3 | US-3.4, US-3.8 |
| notification_template.rb | Member 3 | US-3.3, US-3.6, US-3.7, US-3.8 |

## 💡 Tips

1. **Read the comments** - Each template has detailed comments explaining the model's purpose
2. **Follow the pattern** - Use the same association style across your models
3. **Refer to docs** - Check DEVELOPER_GUIDE.md for API endpoints and database info
4. **Don't overwrite** - These templates are references; customize them for your needs

## 🔗 Related Documentation

- [DEVELOPER_GUIDE.md](../DEVELOPER_GUIDE.md) - Quick reference for all developers
- [ACTION_CABLE_SETUP.md](../ACTION_CABLE_SETUP.md) - Real-time implementation
- [db/MIGRATION_GUIDE.md](../db/MIGRATION_GUIDE.md) - Database migration templates
- [PROJECT_MANAGEMENT.md](../PROJECT_MANAGEMENT.md) - User stories and sprint planning

---

**Created**: February 18, 2026
