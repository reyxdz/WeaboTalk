# Daisy UI Setup Guide

**WeaboTalk** now uses **Daisy UI** for beautiful, accessible component-based styling with Tailwind CSS.

---

## 🎨 What is Daisy UI?

Daisy UI is a component library built on Tailwind CSS that provides:
- ✅ Pre-designed, reusable UI components
- ✅ Beautiful, modern design
- ✅ Accessibility built-in
- ✅ Easy theming and customization
- ✅ No JavaScript dependencies needed

---

## 🚀 Getting Started

### 1. Install Dependencies

```bash
npm install
```

This installs:
- **daisyui**: Component library
- **tailwindcss**: CSS framework
- **@hotwired/stimulus**: JavaScript framework
- **@hotwired/turbo-rails**: HTTP over HTML

### 2. Start Development Server

```powershell
$env:POSTGRES_PASSWORD="rey1172003"
./bin/dev
```

This runs:
- Rails server on port 3000
- Tailwind CSS compiler (watches for changes)
- JavaScript bundler (if needed)

---

## 🎯 Common Daisy UI Components

### Button
```erb
<button class="btn">Default Button</button>
<button class="btn btn-primary">Primary Button</button>
<button class="btn btn-secondary">Secondary Button</button>
<button class="btn btn-outline">Outline Button</button>
<button class="btn btn-disabled">Disabled Button</button>
```

### Form Input
```erb
<input type="text" placeholder="Type here" class="input input-bordered w-full max-w-xs" />
<textarea class="textarea textarea-bordered" placeholder="Bio"></textarea>
<select class="select select-bordered w-full max-w-xs">
  <option disabled selected>Pick your reaction</option>
  <option>😍</option>
  <option>😂</option>
</select>
```

### Card
```erb
<div class="card bg-base-100 shadow-xl">
  <div class="card-body">
    <h2 class="card-title">Post Title</h2>
    <p>Post content goes here</p>
    <div class="card-actions justify-end">
      <button class="btn btn-primary">Like</button>
    </div>
  </div>
</div>
```

### Badge
```erb
<div class="badge">default</div>
<div class="badge badge-primary">primary</div>
<div class="badge badge-secondary">secondary</div>
<div class="badge badge-accent">accent</div>
```

### Avatar
```erb
<div class="avatar">
  <div class="w-24 rounded-full">
    <%= image_tag user.profile.avatar, alt: user.profile.username %>
  </div>
</div>
```

### Modal
```erb
<dialog id="my_modal_1" class="modal">
  <div class="modal-box">
    <h3 class="font-bold text-lg">Hello!</h3>
    <p class="py-4">Press ESC key or click the close button to close</p>
    <div class="modal-action">
      <form method="dialog">
        <button class="btn">Close</button>
      </form>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop">
    <button>close</button>
  </form>
</dialog>
```

### Navbar
```erb
<div class="navbar bg-base-100">
  <div class="navbar-start">
    <div class="dropdown">
      <button tabindex="0" class="btn btn-ghost btn-circle">
        <svg class="h-5 w-5" fill="none" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 24 24" stroke="currentColor">
          <path d="M4 6h16M4 12h16M4 18h7"></path>
        </svg>
      </button>
    </div>
  </div>
  <div class="navbar-center">
    <a class="btn btn-ghost text-xl">WeaboTalk</a>
  </div>
  <div class="navbar-end">
    <button class="btn btn-ghost btn-circle">
      <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20"><path d="M10.5 1.5H5.25A3.75 3.75 0 001.5 5.25v9.5A3.75 3.75 0 005.25 18.5h9.5a3.75 3.75 0 003.75-3.75v-5.25"></path></svg>
    </button>
  </div>
</div>
```

---

## 🎨 Custom Theme (WeaboTalk)

The project includes a custom "weabotalk" theme with anime-inspired colors:

```javascript
// tailwind.config.js
weabotalk: {
  "primary": "#7c3aed",      // Purple
  "secondary": "#ec4899",    // Pink
  "accent": "#06b6d4",       // Cyan
  "neutral": "#2a323c",      // Dark
  "base-100": "#1f2937",     // Base
  "info": "#3b82f6",         // Blue
  "success": "#10b981",      // Green
  "warning": "#f59e0b",      // Amber
  "error": "#ef4444",        // Red
}
```

### Using Custom Theme

In your HTML/ERB files:

```html
<html data-theme="weabotalk">
  <!-- Your content uses WeaboTalk colors -->
</html>
```

Or in meta tag:

```erb
<head>
  <meta name="theme-color" data-theme="weabotalk">
</head>
```

---

## 🎓 File Structure

```
WeaboTalk/
├── app/
│   ├── assets/
│   │   ├── tailwind/
│   │   │   └── application.css       ← Tailwind imports
│   │   └── builds/                   ← Compiled CSS output
│   └── views/
│       └── layouts/
│           └── application.html.erb  ← Main layout
├── tailwind.config.js                ← Tailwind + Daisy UI config
├── package.json                      ← npm dependencies
└── Procfile.dev                      ← Dev server startup
```

---

## 🔧 Common Tasks

### Add a new component
1. Check [Daisy UI docs](https://daisyui.com/components/)
2. Copy the component code
3. Customize colors/classes as needed
4. Test in development

### Change theme colors
1. Edit `tailwind.config.js`
2. Modify the `weabotalk` theme object
3. Save and browser auto-refreshes
4. Or restart `.bin/dev` if needed

### Add Daisy UI icons
Use Heroicons (recommended):
```bash
npm install heroicons
```

```erb
<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8m0 8l-9-2m9 2l9-2m-9-8l8-4m-8 4l-8-4m8 4v8m0-8l4-2m-4 2l-4-2"/>
</svg>
```

---

## 📚 Resources

- **Daisy UI Docs**: https://daisyui.com
- **Tailwind CSS Docs**: https://tailwindcss.com/docs
- **Tailwind CSS Cheat Sheet**: https://tailwindcss.com/docs/installation
- **Daisy UI Components Gallery**: https://daisyui.com/components

---

## 👥 Team Guide

### Member 2 (Frontend/Posts) - Primary Daisy UI User
- Create post forms using `<input>`, `<textarea>` components
- Use `card` component for post display
- Build image upload with `input type="file"`
- Style with Daisy UI buttons and badges

### Member 3 (Social Features) - Secondary Daisy UI User
- Create comment cards with `card` component
- Build notification system with alerts
- Style friend request buttons with `btn` variants
- Design reaction picker with badge components

### Member 1 (Auth) - Layout Builder
- Setup main navbar using `navbar` component
- Create auth forms with form inputs
- Build profile card with `avatar` component
- Style navigation and user menu

---

## 🚀 Getting Started

```powershell
# 1. Install npm dependencies
npm install

# 2. Start development
$env:POSTGRES_PASSWORD="rey1172003"
./bin/dev

# 3. Open browser
# http://127.0.0.1:3000

# 4. Start building with Daisy UI components!
```

---

**Happy coding with Daisy UI!** 🎨✨

**Last Updated**: February 18, 2026
