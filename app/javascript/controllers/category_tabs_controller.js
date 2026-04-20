import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content", "indicator"]

  connect() {
    this.currentId = null
    this.pendingId = null
    this.lockId = null
    this.showTimeout = null
    this.hideTimeout = null
    this.lockTimeout = null
    // 设置延迟常量
    this.enterDelay = 50 // 毫秒，使其几乎立刻出现
    this.leaveDelay = 200 // 保持适当的离开缓冲区
  }

  disconnect() {
    this.clearTimers()
    this.resetIndicators()
    if (this.lockTimeout) clearTimeout(this.lockTimeout)
  }

  // 鼠标进入一级菜单项
  toggle(event) {
    const categoryId = event.currentTarget.dataset.id
    if (!categoryId) return 

    // 如果当前处于点击锁定状态，且触发的不是锁定的 ID，则拦截所有误触触发
    if (this.lockId && this.lockId !== categoryId) {
      return
    }
    
    // 如果已经打开了这个 ID，只需清除隐藏定时器
    if (this.currentId === categoryId) {
      if (this.hideTimeout) {
        clearTimeout(this.hideTimeout)
        this.hideTimeout = null
      }
      return
    }

    // 如果正在等待打开另一个 ID，先取消它
    if (this.showTimeout) {
      clearTimeout(this.showTimeout)
    }

    this.pendingId = categoryId
    
    // 启动延迟显示
    this.showTimeout = setTimeout(() => {
      if (this.pendingId === categoryId) {
        this.show(categoryId)
      }
    }, this.enterDelay)
  }

  // 鼠标离开一级菜单项或整个导航区域
  hideAll(event) {
    // 如果处于锁定状态，不自动隐藏
    if (this.lockId) return

    // 如果是划出到另一个一级菜单，由 toggle 处理。这里处理划出到外部。
    if (this.showTimeout) {
      clearTimeout(this.showTimeout)
      this.showTimeout = null
    }
    
    if (this.hideTimeout) clearTimeout(this.hideTimeout)

    this.hideTimeout = setTimeout(() => {
      this.forceHide()
    }, this.leaveDelay)
  }

  // 执行显示逻辑
  show(categoryId) {
    this.currentId = categoryId
    this.pendingId = null
    
    this.tabTargets.forEach(tab => {
      const active = tab.dataset.id === categoryId
      tab.classList.toggle("bg-gray-100", active)
      tab.classList.toggle("text-blue-600", active)
    })

    this.contentTargets.forEach(content => {
      const active = content.dataset.id === categoryId
      content.classList.toggle("hidden", !active)
    })
  }

  // 强制隐藏所有
  forceHide() {
    if (this.lockId) return
    this.currentId = null
    this.pendingId = null
    
    this.tabTargets.forEach(tab => {
      tab.classList.remove("bg-gray-100", "text-blue-600")
    })

    this.contentTargets.forEach(content => {
      content.classList.add("hidden")
    })
  }

  // 点击一级菜单锁定当前内容 3 秒
  lock(event) {
    // 阻止链接默认跳转行为，除非用户再次点击
    const categoryId = event.currentTarget.dataset.id
    if (!categoryId) return

    // 如果点击的是已经锁定的分类，允许正常跳转（通过 a 标签）
    if (this.lockId === categoryId) {
      return
    }

    // 第一次点击：锁定并显示，阻止跳转
    event.preventDefault()
    
    this.clearTimers()
    if (this.lockTimeout) clearTimeout(this.lockTimeout)

    this.lockId = categoryId
    this.show(categoryId)

    // 显示暗示动画 (进度条)
    this.startIndicator(categoryId)

    // 3秒后解锁
    this.lockTimeout = setTimeout(() => {
      this.lockId = null
      this.resetIndicators()
    }, 1000)
  }

  startIndicator(categoryId) {
    this.resetIndicators()
    const indicator = this.indicatorTargets.find(i => i.dataset.id === categoryId)
    if (indicator) {
      // 初始状态
      indicator.classList.remove("transition-none")
      indicator.style.transition = "none"
      indicator.style.width = "100%"
      indicator.style.opacity = "1"
      
      // 强制重绘
      indicator.offsetHeight 
      
      // 启动平滑缩减动画 (3秒从 100% 到 0%)
      indicator.style.transition = "width 3s linear, opacity 0.3s ease"
      indicator.style.width = "0%"
    }
  }

  resetIndicators() {
    this.indicatorTargets.forEach(indicator => {
      indicator.style.transition = "none"
      indicator.style.width = "0"
      indicator.style.opacity = "0"
    })
  }

  clearTimers() {
    if (this.showTimeout) clearTimeout(this.showTimeout)
    if (this.hideTimeout) clearTimeout(this.hideTimeout)
  }
}
