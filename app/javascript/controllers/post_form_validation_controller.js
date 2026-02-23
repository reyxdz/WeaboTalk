import { Controller } from "@hotwired/stimulus"

/**
 * Post Form Real-Time Validation Controller
 * 
 * Clean Architecture Features:
 * - Separation of concerns: validation, UI feedback, event handling
 * - Debounced validation to prevent excessive API calls
 * - Character counter and dynamic feedback
 * - Visual state indicators (valid, invalid, pending)
 * - Proper loading states during validation
 */
export default class extends Controller {
  static targets = ["title", "content", "submitButton", "charCounter"]
  static values = {
    validationUrl: String
  }

  // Validation configuration with constraints
  VALIDATION_CONFIG = {
    title: {
      minLength: 3,
      maxLength: 200,
      placeholder: "Post title (3-200 characters)"
    },
    content: {
      minLength: 1,
      maxLength: 5000,
      placeholder: "Share your thoughts (1-5000 characters)"
    }
  }

  connect() {
    this.debounceTimers = {}
    this.validationState = {}
    this.setupEventListeners()
    this.initializeFieldStates()
  }

  disconnect() {
    this.clearAllDebounce()
  }

  /**
   * Setup event listeners for form fields
   * Separate handlers for different interaction types
   */
  setupEventListeners() {
    // Title field
    if (this.hasTitleTarget) {
      this.titleTarget.addEventListener("input", (e) => this.handleTitleInput(e))
      this.titleTarget.addEventListener("blur", (e) => this.handleTitleBlur(e))
      this.titleTarget.addEventListener("focus", (e) => this.handleTitleFocus(e))
    }

    // Content field
    if (this.hasContentTarget) {
      this.contentTarget.addEventListener("input", (e) => this.handleContentInput(e))
      this.contentTarget.addEventListener("blur", (e) => this.handleContentBlur(e))
      this.contentTarget.addEventListener("focus", (e) => this.handleContentFocus(e))
    }
  }

  /**
   * Initialize validation state for all fields
   */
  initializeFieldStates() {
    this.validationState.title = { touched: false, valid: false, errors: [] }
    this.validationState.content = { touched: false, valid: false, errors: [] }
    this.updateSubmitButtonState()
  }

  /**
   * ==================== Title Field Handlers ====================
   */

  handleTitleInput(event) {
    const field = event.target
    this.updateCharCounter("title", field.value.length)
    this.validationState.title.touched = true
    this.debounceValidation("title", field.value)
  }

  handleTitleBlur(event) {
    const field = event.target
    // Immediate validation on blur
    this.clearDebounce("title")
    this.validateField("title", field.value)
  }

  handleTitleFocus(event) {
    const field = event.target
    this.showFieldGuidance("title")
  }

  /**
   * ==================== Content Field Handlers ====================
   */

  handleContentInput(event) {
    const field = event.target
    this.updateCharCounter("content", field.value.length)
    this.validationState.content.touched = true
    this.debounceValidation("content", field.value)
  }

  handleContentBlur(event) {
    const field = event.target
    // Immediate validation on blur
    this.clearDebounce("content")
    this.validateField("content", field.value)
  }

  handleContentFocus(event) {
    const field = event.target
    this.showFieldGuidance("content")
  }

  /**
   * ==================== Validation Logic ====================
   */

  /**
   * Debounced validation while user is typing
   */
  debounceValidation(fieldName, value) {
    this.clearDebounce(fieldName)

    // Show pending state
    this.setFieldState(fieldName, "pending")

    // Set debounce timer
    this.debounceTimers[fieldName] = setTimeout(() => {
      this.validateField(fieldName, value)
    }, 500)
  }

  /**
   * Immediate field validation
   */
  async validateField(fieldName, value) {
    if (!value && value !== "") {
      return
    }

    try {
      const response = await fetch(this.validationUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.getCsrfToken()
        },
        body: JSON.stringify({
          field: fieldName,
          value: value,
          form_type: "post"
        })
      })

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`)
      }

      const data = await response.json()
      this.handleValidationResponse(fieldName, data, value)
    } catch (error) {
      console.error(`Validation error for ${fieldName}:`, error)
      this.setFieldState(fieldName, "error")
    }
  }

  /**
   * Handle validation response from server
   */
  handleValidationResponse(fieldName, data, value) {
    const errors = data.errors || []

    // Update validation state
    this.validationState[fieldName].errors = errors
    this.validationState[fieldName].valid = errors.length === 0 && value.length > 0

    // Determine field state
    const fieldState = this.determineFieldState(fieldName, value, errors)
    this.setFieldState(fieldName, fieldState)

    // Update submit button
    this.updateSubmitButtonState()
  }

  /**
   * Determine the visual state of a field based on validation result
   */
  determineFieldState(fieldName, value, errors) {
    // Empty field - default state
    if (value.length === 0) {
      return "default"
    }

    // Has errors - error state
    if (errors.length > 0) {
      return "error"
    }

    // No errors and has content - valid state
    return "valid"
  }

  /**
   * ==================== UI State Management ====================
   */

  /**
   * Set visual state for a field
   */
  setFieldState(fieldName, state) {
    const field = this[`${fieldName}Target`]
    if (!field) return

    // Remove all state classes
    field.classList.remove("border-slate-600/50", "focus:ring-purple-500")
    field.classList.remove("border-rose-500", "focus:ring-rose-500")
    field.classList.remove("border-green-500", "focus:ring-green-500")
    field.classList.remove("bg-slate-800/50", "bg-rose-900/20", "bg-green-900/20")

    // Remove feedback message
    const feedbackId = `${fieldName}-feedback`
    const existingFeedback = document.getElementById(feedbackId)
    if (existingFeedback) {
      existingFeedback.remove()
    }

    // Apply state styles and messages
    switch (state) {
      case "valid":
        field.classList.add("border-green-500", "focus:ring-green-500", "bg-green-900/10")
        this.showFieldFeedback(fieldName, "✓ Valid", "valid")
        break

      case "error":
        field.classList.add("border-rose-500", "focus:ring-rose-500", "bg-rose-900/20")
        this.showFieldFeedback(fieldName, this.validationState[fieldName].errors[0], "error")
        break

      case "pending":
        field.classList.add("border-purple-500/50", "focus:ring-purple-400", "bg-purple-900/10")
        this.showFieldFeedback(fieldName, "Validating...", "pending")
        break

      default: // default
        field.classList.add("border-slate-600/50", "focus:ring-purple-500", "bg-slate-800/50")
        this.clearFieldFeedback(fieldName)
    }
  }

  /**
   * Show validation feedback for a field
   */
  showFieldFeedback(fieldName, message, type) {
    const field = this[`${fieldName}Target`]
    if (!field) return

    const feedbackId = `${fieldName}-feedback`
    let feedbackElement = document.getElementById(feedbackId)

    if (!feedbackElement) {
      feedbackElement = document.createElement("div")
      feedbackElement.id = feedbackId
      feedbackElement.className = "mt-2 text-sm font-medium transition"
      field.parentElement.appendChild(feedbackElement)
    }

    feedbackElement.style.display = "block"

    switch (type) {
      case "valid":
        feedbackElement.className = "mt-2 text-sm font-medium text-green-400"
        feedbackElement.innerHTML = `<span class="flex items-center gap-1"><svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>${message}</span>`
        break

      case "error":
        feedbackElement.className = "mt-2 text-sm font-medium text-rose-400"
        feedbackElement.innerHTML = `<span class="flex items-center gap-1"><svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/></svg>${message}</span>`
        break

      case "pending":
        feedbackElement.className = "mt-2 text-sm font-medium text-purple-400"
        feedbackElement.innerHTML = `<span class="flex items-center gap-1"><svg class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>Validating...</span>`
        break
    }
  }

  /**
   * Clear validation feedback for a field
   */
  clearFieldFeedback(fieldName) {
    const feedbackId = `${fieldName}-feedback`
    const feedbackElement = document.getElementById(feedbackId)
    if (feedbackElement) {
      feedbackElement.remove()
    }
  }

  /**
   * Update character counter for a field
   */
  updateCharCounter(fieldName, currentLength) {
    const config = this.VALIDATION_CONFIG[fieldName]
    if (!config) return

    const counterId = `${fieldName}-char-count`
    let counter = document.getElementById(counterId)

    if (!counter) {
      const field = this[`${fieldName}Target`]
      if (!field) return

      counter = document.createElement("div")
      counter.id = counterId
      counter.className = "mt-1 text-xs text-slate-400"
      field.parentElement.appendChild(counter)
    }

    const percentage = Math.round((currentLength / config.maxLength) * 100)
    const statusColor = this.getCounterStatusColor(percentage)

    counter.innerHTML = `
      <div class="flex items-center justify-between">
        <span>${currentLength} / ${config.maxLength} characters</span>
        <div class="w-20 h-1.5 bg-slate-700/50 rounded-full overflow-hidden">
          <div class="h-full rounded-full transition-all" style="width: ${percentage}%; background-color: ${statusColor};"></div>
        </div>
      </div>
    `
  }

  /**
   * Get status color for character counter based on usage percentage
   */
  getCounterStatusColor(percentage) {
    if (percentage >= 90) return "rgb(244, 63, 94)" // rose
    if (percentage >= 75) return "rgb(251, 146, 60)" // orange
    if (percentage >= 50) return "rgb(168, 85, 247)" // purple
    return "rgb(59, 130, 246)" // blue
  }

  /**
   * Show field guidance/help text
   */
  showFieldGuidance(fieldName) {
    const config = this.VALIDATION_CONFIG[fieldName]
    if (!config) return

    const guidanceId = `${fieldName}-guidance`
    let guidance = document.getElementById(guidanceId)

    if (!guidance) {
      const field = this[`${fieldName}Target`]
      if (!field) return

      guidance = document.createElement("div")
      guidance.id = guidanceId
      guidance.className = "mt-2 text-xs text-slate-400 italic"
      field.parentElement.appendChild(guidance)
    }

    guidance.textContent = `${config.placeholder} (${config.minLength}-${config.maxLength})`
    guidance.style.display = "block"
  }

  /**
   * Update submit button enabled/disabled state
   */
  updateSubmitButtonState() {
    if (!this.hasSubmitButtonTarget) return

    const titleValid = this.validationState.title.valid || !this.validationState.title.touched
    const contentValid = this.validationState.content.valid || !this.validationState.content.touched
    const isFormValid = titleValid && contentValid

    // Check if at least one field has content
    const hasContent = this.getTitleValue().length > 0 || this.getContentValue().length > 0

    this.submitButtonTarget.disabled = !isFormValid || !hasContent
    this.submitButtonTarget.style.opacity = this.submitButtonTarget.disabled ? "0.6" : "1"
    this.submitButtonTarget.style.cursor = this.submitButtonTarget.disabled ? "not-allowed" : "pointer"
  }

  /**
   * ==================== Utility Methods ====================
   */

  /**
   * Get field values
   */
  getTitleValue() {
    return this.hasTitleTarget ? this.titleTarget.value.trim() : ""
  }

  getContentValue() {
    return this.hasContentTarget ? this.contentTarget.value.trim() : ""
  }

  /**
   * Clear debounce timer
   */
  clearDebounce(fieldName) {
    if (this.debounceTimers[fieldName]) {
      clearTimeout(this.debounceTimers[fieldName])
      delete this.debounceTimers[fieldName]
    }
  }

  /**
   * Clear all debounce timers
   */
  clearAllDebounce() {
    Object.keys(this.debounceTimers).forEach((fieldName) => {
      this.clearDebounce(fieldName)
    })
  }

  /**
   * Get CSRF token from meta tag
   */
  getCsrfToken() {
    const token = document.querySelector('meta[name="csrf-token"]')
    return token ? token.getAttribute("content") : ""
  }
}
