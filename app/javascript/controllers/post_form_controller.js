import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  addImage() {
    const container = this.containerTarget
    const newIndex = Math.floor(Math.random() * 10000)
    
    const fieldHTML = `
      <div class="flex gap-3 items-end image-wrapper">
        <div class="flex-1">
          <input type="file" accept="image/*" name="post[post_images_attributes][${newIndex}][image]" class="w-full bg-slate-800/50 border border-slate-600/50 rounded-lg px-3 py-2 text-slate-100 file:mr-4 file:py-2 file:px-3 file:rounded file:border-0 file:bg-purple-600 file:text-white file:font-semibold file:cursor-pointer hover:file:bg-purple-700" />
        </div>
        <button type="button" class="px-4 py-2 bg-rose-600/50 hover:bg-rose-600 text-rose-100 rounded-lg text-sm font-semibold transition" data-action="click->post-form#removeImage">Remove</button>
      </div>
    `
    
    const div = document.createElement('div')
    div.innerHTML = fieldHTML
    container.appendChild(div.firstElementChild)
  }

  removeImage(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.image-wrapper')
    if (wrapper) {
      wrapper.remove()
    }
  }
}

