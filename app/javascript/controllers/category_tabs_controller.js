import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    this.currentId = null
    this.pendingId = null
    this.showTimeout = null
    this.hideTimeout = null
    // 设置延迟常量
    this.enterDelay = 150 // 毫秒，恢复到一个较快但稳定的值
    this.leaveDelay = 500 // 增加离开延迟，防止稍微滑出就消失
    
    // 用于跟踪鼠标位置
    this.mouseLocs = []
    this.lastDelayLoc = null
    this.trackMouseHandler = this.trackMouse.bind(this)
    document.addEventListener("mousemove", this.trackMouseHandler)
  }

  disconnect() {
    this.clearTimers()
    document.removeEventListener("mousemove", this.trackMouseHandler)
  }

  trackMouse(event) {
    this.mouseLocs.push({ x: event.pageX, y: event.pageY })
    if (this.mouseLocs.length > 10) {
      this.mouseLocs.shift()
    }
  }

  isMovingTowardsContent() {
    if (!this.currentId || this.mouseLocs.length < 3) return false

    const activeContent = this.contentTargets.find(c => c.dataset.id === this.currentId)
    if (!activeContent || activeContent.classList.contains("hidden")) return false

    const rect = activeContent.getBoundingClientRect()
    const curr = this.mouseLocs[this.mouseLocs.length - 1]
    const prev = this.mouseLocs[0]

    // 如果鼠标在向上移动，肯定不是去内容区
    if (curr.y < prev.y) return false

    // 目标区域（内容区的左下角和右下角）
    const lowerLeft = { x: rect.left + window.scrollX, y: rect.bottom + window.scrollY }
    const lowerRight = { x: rect.right + window.scrollX, y: rect.bottom + window.scrollY }
    const upperLeft = { x: rect.left + window.scrollX, y: rect.top + window.scrollY }
    const upperRight = { x: rect.right + window.scrollX, y: rect.top + window.scrollY }

    // 使用 prev 作为顶点，检查 curr 是否在由 prev 与内容区底部形成的三角形内
    // 这样可以更准确地判断“移动趋势”
    return this.isPointInTriangle(curr, prev, lowerLeft, lowerRight) ||
           this.isPointInTriangle(curr, prev, upperLeft, upperRight)
  }

  isPointInTriangle(p, a, b, c) {
    const b1 = this.sign(p, a, b) < 0.0
    const b2 = this.sign(p, b, c) < 0.0
    const b3 = this.sign(p, c, a) < 0.0
    return ((b1 === b2) && (b2 === b3))
  }

  sign(p1, p2, p3) {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
  }

  // 鼠标进入一级菜单项
  toggle(event) {
    const categoryId = event.currentTarget.dataset.id
    if (!categoryId) return 
    
    // 如果已经打开了这个 ID，只需清除隐藏定时器
    if (this.currentId === categoryId) {
      if (this.hideTimeout) {
        clearTimeout(this.hideTimeout)
        this.hideTimeout = null
      }
      return
    }

  // 关键优化：如果当前已经有打开的菜单，且鼠标正在向内容区移动，则暂时忽略新的一级菜单触发
    // 使用更长的延迟来验证用户意图
    if (this.currentId && this.isMovingTowardsContent()) {
      if (this.showTimeout) clearTimeout(this.showTimeout)
      this.pendingId = categoryId
      this.showTimeout = setTimeout(() => {
        if (this.pendingId === categoryId) {
          this.show(categoryId)
        }
      }, 500) // 如果在斜向移动过程中鼠标在某个新项上停留超过500ms，才认为真的想换
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
    this.currentId = null
    this.pendingId = null
    
    this.tabTargets.forEach(tab => {
      tab.classList.remove("bg-gray-100", "text-blue-600")
    })

    this.contentTargets.forEach(content => {
      content.classList.add("hidden")
    })
  }

  clearTimers() {
    if (this.showTimeout) clearTimeout(this.showTimeout)
    if (this.hideTimeout) clearTimeout(this.hideTimeout)
  }
}
