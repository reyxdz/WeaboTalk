import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["friendButton"]

  connect() {
    // Any initialization for friend buttons
  }

  updateFriendButton(event) {
    this.dispatch('friend-status-changed', { detail: { status: event.detail.status } })
  }
}
