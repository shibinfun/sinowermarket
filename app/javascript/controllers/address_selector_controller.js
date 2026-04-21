import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    const button = event.currentTarget
    const name = button.dataset.name
    const phone = button.dataset.phone
    const address = button.dataset.fullAddress

    // Find the form with order-form controller
    const form = document.querySelector('[data-controller="order-form"]')
    if (form) {
      const nameInput = form.querySelector('[data-order-form-target="name"]')
      const phoneInput = form.querySelector('[data-order-form-target="phone"]')
      const addressInput = form.querySelector('[data-order-form-target="address"]')

      if (nameInput) nameInput.value = name
      if (phoneInput) phoneInput.value = phone
      if (addressInput) addressInput.value = address

      // Visual feedback
      this.highlightSelected(button)
    }
  }

  highlightSelected(selectedButton) {
    const buttons = this.element.querySelectorAll('button')
    buttons.forEach(btn => {
      btn.classList.remove('border-blue-500', 'bg-blue-50/30')
      btn.classList.add('border-gray-200')
    })

    selectedButton.classList.remove('border-gray-200')
    selectedButton.classList.add('border-blue-500', 'bg-blue-50/30')
  }
}
