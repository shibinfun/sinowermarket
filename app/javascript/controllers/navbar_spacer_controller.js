import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.adjustSpacer()
    window.addEventListener("resize", this.adjustSpacer.bind(this))
    
    // 监听导航栏内部变化（比如二级菜单显示/隐藏）
    this.observer = new MutationObserver(this.adjustSpacer.bind(this))
    const navbar = document.querySelector('nav.fixed')
    if (navbar) {
      this.observer.observe(navbar, { attributes: true, childList: true, subtree: true })
    }
  }

  disconnect() {
    window.removeEventListener("resize", this.adjustSpacer.bind(this))
    if (this.observer) this.observer.disconnect()
  }

  adjustSpacer() {
    const navbar = document.querySelector('nav.fixed')
    if (navbar) {
      const height = navbar.offsetHeight
      this.element.style.paddingTop = `${height}px`
    }
  }
}
