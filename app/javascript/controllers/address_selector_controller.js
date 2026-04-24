import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    const button = event.currentTarget
    const name = button.dataset.name
    const phone = button.dataset.phone
    const province = button.dataset.province
    const city = button.dataset.city
    const district = button.dataset.district
    const detailAddress = button.dataset.detailAddress

    // Find the form with order-form controller
    const form = document.querySelector('[data-controller="order-form"]')
    if (form) {
      const nameInput = form.querySelector('[data-order-form-target="name"]')
      const phoneInput = form.querySelector('[data-order-form-target="phone"]')
      const provinceInput = form.querySelector('[data-order-form-target="province"]')
      const cityInput = form.querySelector('[data-order-form-target="city"]')
      const districtInput = form.querySelector('[data-order-form-target="district"]')
      const detailAddressInput = form.querySelector('[data-order-form-target="detailAddress"]')

      if (nameInput) nameInput.value = name
      if (phoneInput) phoneInput.value = phone
      if (provinceInput) provinceInput.value = province
      if (cityInput) cityInput.value = city
      if (districtInput) districtInput.value = district
      if (detailAddressInput) detailAddressInput.value = detailAddress

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
