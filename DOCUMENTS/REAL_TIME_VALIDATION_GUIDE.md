# Real-Time Form Validation Architecture

## Overview

This implementation provides real-time form validation across the entire WeaboTalk application using a clean, maintainable architecture. It validates user input as they type and provides instant feedback.

## Architecture Components

### 1. **Validation Rules Service** (`app/services/forms/validation_rules.rb`)
A centralized service that defines all validation rules for the application:
- Email format validation
- Password strength checks (letters, numbers, special characters, min 8 chars)
- Field length validation (min/max)
- Username format validation (alphanumeric + underscore)
- Comment/Post content validation
- Profile field validation

**Key Feature**: Rules are defined once and can be used anywhere (server-side, client-side, API calls)

```ruby
errors = Forms::ValidationRules.validate("email", "invalid@")
# => ["Please enter a valid email address"]
```

### 2. **Stimulus Form Validation Controller** (`app/javascript/controllers/form_validation_controller.js`)
A reusable Stimulus controller that handles real-time validation:
- **Debounced input validation** (500ms delay while typing)
- **Blur validation** (immediate when user leaves field)
- **Enter key validation** (triggers on Enter press)
- **Form submission validation** (prevents submit if errors exist)
- **Visual feedback** (green checkmark for valid, red X for errors)

### 3. **Forms Controller** (`app/controllers/forms_controller.rb`)
An API endpoint that processes validation requests:
- Handles AJAX POST requests from Stimulus controller
- Parses nested form field names (e.g., `post[title]` → `title`)
- Returns JSON with validation errors
- Maps form types to appropriate validation rules

### 4. **Validation Helper** (`app/helpers/forms/validation_helper.rb`)
Optional helper methods for rendering validated form fields consistently:
- `validated_input` - Text input with validation
- `validated_textarea` - Textarea with validation
- `validated_email_input` - Email field
- `validated_password_input` - Password field with strength requirements

## How It Works

### Flow Diagram
```
User types in field
        ↓
500ms debounce timer
        ↓
Stimulus sends AJAX POST to /forms/validate
        ↓
FormsController validates field using Forms::ValidationRules
        ↓
Returns JSON with errors
        ↓
Stimulus displays visual feedback
        ↓
User sees green ✓ (valid) or red ✗ (invalid)
```

### Form Integration

Each form in the application now includes:

```erb
<%= form_with(
  model: @post, 
  local: true,
  html: { 
    data: { 
      controller: "form-validation",
      validation_url: validate_form_path,
      validation_type: "post"
    }
  }
) do |form| %>
  <!-- Form fields automatically validated -->
<% end %>
```

## Supported Forms

The validation is applied to all forms in the application:
1. **Post Form** - Title (3-200 chars), Content (1-5000 chars)
2. **Comment Form** - Content (1-1000 chars)
3. **User Registration** - Email, Password (8+ chars with strength), Password Confirmation
4. **User Login** - Email, Password
5. **Password Reset** - Email
6. **Password Change** - Current password, New password, Confirmation
7. **Profile Edit** - Username (3-30 alphanumeric+underscore), Bio (0-500 chars)
8. **Email Confirmation** - Email

## Validation Rules

### Email
- Required
- Must be valid email format
- Min 5 characters

### Password
- Required
- Minimum 8 characters
- Must contain: letters, numbers, special characters (@$!%*?&)

### Username
- Required
- 3-30 characters
- Alphanumeric + underscore only

### Post Title
- Required
- 3-200 characters

### Post Content
- Required
- 1-5000 characters

### Comments
- Required
- 1-1000 characters

### Bio (Profile)
- Optional
- Maximum 500 characters

## Visual Feedback

### Valid Field
```
Border: Green
Text: "✓ Valid"
Color: Green (#22c55e)
```

### Invalid Field
```
Border: Red
Text: "✗ Error message"
Color: Red (#ef4444)
```

### Empty Field
```
No feedback shown (wait for user input)
```

## Adding New Validated Fields

### Step 1: Add Validation Rule
Edit `app/services/forms/validation_rules.rb`:

```ruby
RULES = {
  my_field: [
    { type: :presence, message: "My field is required" },
    { type: :min_length, value: 5, message: "Minimum 5 characters" }
  ]
}
```

### Step 2: Add Form Controller Logic (if needed)
Update `app/controllers/forms_controller.rb` field mapping:

```ruby
when /\[my_field\]$/
  "my_field"
```

### Step 3: Use in Form
Just add `data-controller="form-validation"` to your form - validation is automatic!

## API Endpoint

### POST `/forms/validate`

**Request:**
```json
{
  "field": "post[title]",
  "value": "My post",
  "form_type": "post"
}
```

**Response:**
```json
{
  "errors": ["Title must be at least 3 characters"],
  "field": "post[title]"
}
```

## Performance Considerations

1. **Debouncing** - 500ms delay prevents excessive API calls while typing
2. **Event Delegation** - One controller per form, not per field
3. **Field Caching** - Form elements cached on controller connect
4. **Minimal Payload** - Only field name, value, and form type sent

## Browser Support

- Modern browsers with Stimulus and Fetch API support
- Graceful degradation if JavaScript is disabled (server-side validation still works)

## Testing

To test the validation:

```ruby
# In Rails Console
errors = Forms::ValidationRules.validate("email", "invalid")
# => ["Please enter a valid email address"]

errors = Forms::ValidationRules.validate("password", "weak")
# => ["Password must be at least 8 characters", "Password must contain letters, numbers, and special characters"]

errors = Forms::ValidationRules.validate("title", "Hi", "post")
# => ["Title must be at least 3 characters"]
```

## Files Modified

### New Files Created
- `app/services/forms/validation_rules.rb` - Validation rule definitions
- `app/javascript/controllers/form_validation_controller.js` - Stimulus controller
- `app/helpers/forms/validation_helper.rb` - Helper methods for form rendering
- `app/controllers/forms_controller.rb` - API endpoint

### Modified Files
- `app/views/posts/_form.html.erb` - Added validation controller
- `app/views/posts/show.html.erb` - Added validation to comment form
- `app/views/comments/_comment.html.erb` - Added validation to reply form
- `app/views/devise/registrations/new.html.erb` - Added validation
- `app/views/users/sessions/new.html.erb` - Added validation
- `app/views/users/passwords/new.html.erb` - Added validation
- `app/views/users/passwords/edit.html.erb` - Added validation
- `app/views/profiles/edit.html.erb` - Added validation
- `app/views/users/confirmations/new.html.erb` - Added validation
- `config/routes.rb` - Added `/forms/validate` route
- `app/javascript/controllers/index.js` - Registered FormValidationController

## Clean Architecture Principles Applied

✅ **Separation of Concerns** - Rules, controller, UI separated  
✅ **Single Responsibility** - Each file has one job  
✅ **DRY** - Rules defined once, used everywhere  
✅ **Reusability** - Validation works in console, API, UI  
✅ **Testability** - Easy to unit test validation service  
✅ **Maintainability** - Add rules in one place, affects entire app  
✅ **No Duplication** - No client-side/server-side rule duplication  
✅ **Framework Agnostic** - Rules can be used outside Rails if needed  
