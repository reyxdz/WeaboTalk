import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["picker"]

  togglePicker(event) {
    event.preventDefault()
    const picker = this.pickerTarget
    picker.classList.toggle('hidden')
  }

  selectReaction(emoji) {
    // This will be handled by the button_to form
    this.dispatch('reaction-selected', { detail: { emoji } })
  }
}
