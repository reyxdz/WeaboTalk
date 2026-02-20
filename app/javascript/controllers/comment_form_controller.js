import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["replyForm"]

  toggleReplyForm(event) {
    const commentId = event.currentTarget.dataset.commentId
    const formElement = document.getElementById(`reply-form-${commentId}`)
    
    if (formElement) {
      formElement.classList.toggle('hidden')
    }
  }

  closeReplyForms() {
    document.querySelectorAll('[id^="reply-form-"]').forEach(form => {
      form.classList.add('hidden')
    })
  }
}
