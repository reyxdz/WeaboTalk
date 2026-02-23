import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "preview", "charCount", "submitBtn"]
  static values = { maxLength: 5000 }

  connect() {
    this.updateCharCount()
  }

  updateCharCount() {
    const content = this.formTarget.querySelector('[name*="[content]"]')
    if (content) {
      const count = content.value.length
      const remaining = this.maxLengthValue - count
      if (this.hasCharCountTarget) {
        this.charCountTarget.textContent = `${count} / ${this.maxLengthValue}`
        this.charCountTarget.classList.toggle('text-error', remaining < 100)
      }
      if (this.hasSubmitBtnTarget) {
        this.submitBtnTarget.disabled = count === 0 || count > this.maxLengthValue
      }
    }
  }

  updatePreview(event) {
    const content = event.target.value
    if (this.hasPreviewTarget) {
      this.previewTarget.innerHTML = this.escapeHtml(content)
    }
  }

  escapeHtml(text) {
    const map = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#039;'
    }
    return text.replace(/[&<>"']/g, m => map[m])
  }
}
