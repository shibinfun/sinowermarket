import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    this.showTimeout = null
    this.hideTimeout = null
  }

  disconnect() {
    if (this.showTimeout) clearTimeout(this.showTimeout)
    if (this.hideTimeout) clearTimeout(this.hideTimeout)
  }

  toggle(event) {
    const categoryId = event.currentTarget.dataset.id
    
    if (this.showTimeout) clearTimeout(this.showTimeout)
    if (this.hideTimeout) clearTimeout(this.hideTimeout)

    // 150ms 延迟，防止快速滑过时频繁切换
    this.showTimeout = setTimeout(() => {
      this.show(categoryId)
    }, 150)
  }

  show(categoryId) {
    this.tabTargets.forEach(tab => {
      if (tab.dataset.id === categoryId) {
        tab.classList.add("bg-gray-100", "text-blue-600")
      } else {
        tab.classList.remove("bg-gray-100", "text-blue-600")
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
    if (this.showTimeout) clearTimeout(this.showTimeout)
    if (this.hideTimeout) clearTimeout(this.hideTimeout)
    
    // 250ms 缓冲区，允许鼠标斜向移动时短暂离开区域
    this.hideTimeout = setTimeout(() => {
      this.tabTargets.forEach(tab => {
        tab.classList.remove("bg-gray-100", "text-blue-600")
      })

      this.contentTargets.forEach(content => {
        content.classList.add("hidden")
      })
    }, 250)
  }
}
