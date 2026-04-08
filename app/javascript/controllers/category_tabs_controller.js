import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    // 不再默认展示，因为放在了导航栏，初始应该是关闭的
  }

  toggle(event) {
    const categoryId = event.currentTarget.dataset.id
    this.show(categoryId)
  }

  show(categoryId) {
    this.tabTargets.forEach(tab => {
      if (tab.dataset.id === categoryId) {
        tab.classList.add("bg-[#F7F7F7]", "text-blue-600")
      } else {
        tab.classList.remove("bg-[#F7F7F7]", "text-blue-600")
      }
    })

    this.contentTargets.forEach(content => {
      if (content.dataset.id === categoryId) {
        content.classList.remove("hidden")
      } else {
        content.classList.add("hidden")
      }
    })
  }

  hideAll() {
    this.tabTargets.forEach(tab => {
      tab.classList.remove("bg-[#F7F7F7]", "text-blue-600")
    })

    this.contentTargets.forEach(content => {
      content.classList.add("hidden")
    })
  }
}
