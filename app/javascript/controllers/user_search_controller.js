import { Controller } from "@hotwired/stimulus"

/**
 * Clean, robust search controller with proper event handling and state management
 * Handles both typing (debounced) and explicit search actions (Enter/Button)
 */
export default class extends Controller {
  static targets = ["input", "results", "loader", "submitButton"]
  static values = {
    searchUrl: String,
    minLength: { type: Number, default: 1 },
    debounceDelay: { type: Number, default: 300 }
  }

  connect() {
    this.debounceTimer = null
    this.currentQuery = ""
    this.isLoading = false
    this.setupEventListeners()
    this.updateButtonState()
  }

  disconnect() {
    this.clearDebounce()
  }

  /**
   * Setup event listeners with proper delegation
   */
  setupEventListeners() {
    // Listen to input changes for button state and debounced search
    this.inputTarget.addEventListener("input", (e) => this.handleInput(e))
    // Allow explicit Enter key handling even if debounced search is active
    this.inputTarget.addEventListener("keydown", (e) => this.handleKeyDown(e))
    // Button click - always works when enabled
    this.submitButtonTarget.addEventListener("click", (e) => this.handleButtonClick(e))
  }

  /**
   * Handle input event - update button state and trigger debounced search
   */
  handleInput(event) {
    this.updateButtonState()
    const query = this.inputTarget.value.trim()

    if (query.length === 0) {
      this.clearResults()
      this.clearDebounce()
      return
    }

    if (query.length < this.minLengthValue) {
      this.clearResults()
      return
    }

    // Debounced search while typing
    this.clearDebounce()
    this.debounceTimer = setTimeout(() => {
      this.performSearch(query)
    }, this.debounceDelayValue)
  }

  /**
   * Handle keydown event - catch Enter key for immediate search
   */
  handleKeyDown(event) {
    if (event.key === "Enter" || event.code === "Enter") {
      event.preventDefault()
      this.clearDebounce()
      const query = this.inputTarget.value.trim()
      if (query.length >= this.minLengthValue) {
        this.performSearch(query)
      }
    }
  }

  /**
   * Handle button click - explicit search action
   */
  handleButtonClick(event) {
    event.preventDefault()
    event.stopPropagation()
    
    this.clearDebounce()
    const query = this.inputTarget.value.trim()
    
    if (query.length >= this.minLengthValue && !this.isLoading) {
      this.performSearch(query)
    }
  }

  /**
   * Update button enabled/disabled state based on input length and loading state
   */
  updateButtonState() {
    const hasValidInput = this.inputTarget.value.trim().length >= this.minLengthValue
    const shouldBeEnabled = hasValidInput && !this.isLoading
    this.submitButtonTarget.disabled = !shouldBeEnabled
    this.submitButtonTarget.style.opacity = shouldBeEnabled ? "1" : "0.5"
    this.submitButtonTarget.style.cursor = shouldBeEnabled ? "pointer" : "not-allowed"
  }

  /**
   * Main search execution method
   */
  async performSearch(query) {
    if (this.isLoading || query.length < this.minLengthValue) {
      return
    }

    this.currentQuery = query
    this.isLoading = true
    this.showLoader()
    this.updateButtonState()

    try {
      const response = await fetch(this.searchUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.getCsrfToken()
        },
        body: JSON.stringify({ q: query })
      })

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`)
      }

      const data = await response.json()
      this.displayResults(data.users || [], query)
    } catch (error) {
      this.showError(`Search failed: ${error.message}`)
    } finally {
      this.isLoading = false
      this.hideLoader()
      this.updateButtonState()
    }
  }

  /**
   * Display search results in the dropdown
   */
  displayResults(users, query) {
    if (!users || users.length === 0) {
      this.resultsTarget.innerHTML = `
        <div class="py-8 text-center text-slate-400">
          <p class="text-sm">No users found matching "<strong>${this.escapeHtml(query)}</strong>"</p>
          <p class="text-xs mt-2 text-slate-500">Try searching by username or bio</p>
        </div>
      `
      this.showResultsDropdown()
      return
    }

    const resultsHtml = users
      .map((user) => this.buildResultItem(user))
      .join("")

    this.resultsTarget.innerHTML = resultsHtml
    this.showResultsDropdown()
  }

  /**
   * Build individual result item HTML
   */
  buildResultItem(user) {
    const avatarHtml = user.avatar
      ? `<img src="${user.avatar}" alt="${user.username}" class="w-12 h-12 rounded-full object-cover">`
      : `<div class="w-12 h-12 rounded-full bg-gradient-to-br from-purple-500 to-pink-500 flex items-center justify-center text-white font-bold text-lg">${user.username.charAt(0).toUpperCase()}</div>`

    return `
      <a href="/profiles/${user.username}" 
         class="block bg-slate-800/70 hover:bg-slate-700/70 active:bg-slate-600/70 transition rounded-lg p-4 border border-slate-700/50 hover:border-purple-500/50 group cursor-pointer"
         tabindex="0">
        <div class="flex items-center gap-4">
          ${avatarHtml}
          <div class="flex-1 min-w-0">
            <h3 class="font-semibold text-slate-100 group-hover:text-purple-400 transition">${this.escapeHtml(user.username)}</h3>
            <p class="text-sm text-slate-400 truncate">${this.escapeHtml(user.bio)}</p>
            <p class="text-xs text-slate-500 mt-1">👥 ${user.friends_count} friend${user.friends_count !== 1 ? "s" : ""}</p>
          </div>
        </div>
      </a>
    `
  }

  /**
   * Show results dropdown
   */
  showResultsDropdown() {
    this.resultsTarget.classList.remove("hidden")
  }

  /**
   * Clear results and hide dropdown
   */
  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
  }

  /**
   * Show/hide loading indicator
   */
  showLoader() {
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.remove("hidden")
    }
  }

  hideLoader() {
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.add("hidden")
    }
  }

  /**
   * Show error message
   */
  showError(message) {
    this.resultsTarget.innerHTML = `
      <div class="py-8 text-center text-rose-400">
        <p class="text-sm">⚠️ ${message}</p>
        <p class="text-xs mt-2 text-slate-500">Please try again</p>
      </div>
    `
    this.showResultsDropdown()
  }

  /**
   * Clear debounce timer
   */
  clearDebounce() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
      this.debounceTimer = null
    }
  }

  /**
   * Get CSRF token from meta tag
   */
  getCsrfToken() {
    const token = document.querySelector('meta[name="csrf-token"]')
    return token ? token.getAttribute("content") : ""
  }

  /**
   * Escape HTML to prevent XSS attacks
   */
  escapeHtml(text) {
    if (!text) return ""
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
