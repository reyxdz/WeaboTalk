import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "feedback"]
  static values = {
    validationUrl: String
  }

  connect() {
    // Attach validation handlers to input-like elements
    this.element.querySelectorAll("input, textarea, select").forEach((field) => {
      if (!field.classList.contains("no-validation")) {
        field.addEventListener("blur", () => this.validateField(field))
        field.addEventListener("input", () => this.debounceValidation(field))
        
        // Auto-validate on enter for forms
        if (field.tagName === "INPUT" || field.tagName === "TEXTAREA") {
          field.addEventListener("keyup", (e) => {
            if (e.key === "Enter") this.validateField(field)
          })
        }
      }
    })
  }

  // Debounced validation during typing (wait 500ms after user stops typing)
  debounceValidation(field) {
    if (field.dataset.validationTimeout) {
      clearTimeout(field.dataset.validationTimeout)
    }
    
    field.dataset.validationTimeout = setTimeout(() => {
      this.validateField(field)
      delete field.dataset.validationTimeout
    }, 500)
  }

  // Fetch validation errors from the server
  async validateField(field) {
    const fieldName = field.name || field.id
    const value = field.value
    const formElement = field.closest("form")
    
    if (!fieldName) return

    try {
      const response = await fetch(this.validationUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          field: fieldName,
          value: value,
          form_type: formElement?.dataset.validationType || "generic"
        })
      })

      const data = await response.json()
      this.displayValidationFeedback(field, data.errors, fieldName)
    } catch (error) {
      console.error("Validation error:", error)
    }
  }

  // Display validation feedback (errors or success)
  displayValidationFeedback(field, errors, fieldName) {
    const feedbackId = `${fieldName}-feedback`
    let feedbackElement = document.getElementById(feedbackId)

    if (!feedbackElement) {
      feedbackElement = document.createElement("div")
      feedbackElement.id = feedbackId
      feedbackElement.className = "mt-1 text-sm"
      field.parentElement.appendChild(feedbackElement)
    }

    field.classList.remove("border-rose-500", "focus:ring-rose-500", "border-green-500", "focus:ring-green-500")

    if (errors && errors.length > 0) {
      field.classList.add("border-rose-500", "focus:ring-rose-500")
      feedbackElement.className = "mt-1 text-sm text-rose-500 font-medium"
      feedbackElement.innerHTML = errors.map((e) => `<div>✗ ${e}</div>`).join("")
      feedbackElement.style.display = "block"
    } else if (field.value.length > 0) {
      field.classList.add("border-green-500", "focus:ring-green-500")
      feedbackElement.className = "mt-1 text-sm text-green-500 font-medium"
      feedbackElement.innerHTML = "<div>✓ Valid</div>"
      feedbackElement.style.display = "block"
    } else {
      feedbackElement.style.display = "none"
    }
  }

  // Validate entire form before submission
  validateForm(event) {
    if (event.target.dataset.skipValidation === "true") return

    const fields = this.element.querySelectorAll("input, textarea, select")
    let isValid = true

    fields.forEach((field) => {
      if (!field.classList.contains("no-validation")) {
        this.validateField(field)
        if (field.classList.contains("border-rose-500")) {
          isValid = false
        }
      }
    })

    if (!isValid) {
      event.preventDefault()
      this.showValidationErrorMessage()
    }
  }

  // Show a summary error message
  showValidationErrorMessage() {
    const errorContainer = this.element.querySelector("[data-validation-errors]")
    if (errorContainer) {
      errorContainer.style.display = "block"
      setTimeout(() => {
        errorContainer.style.display = "none"
      }, 5000)
    }
  }
}
