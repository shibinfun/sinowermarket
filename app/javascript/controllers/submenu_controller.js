import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    const chevron = this.element.querySelector(".submenu-chevron")
    if (chevron) {
      chevron.classList.toggle("rotate-90")
    }
  }
}
