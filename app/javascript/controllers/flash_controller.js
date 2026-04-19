import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    this.element.classList.add("animate-out", "fade-out", "duration-500")
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
