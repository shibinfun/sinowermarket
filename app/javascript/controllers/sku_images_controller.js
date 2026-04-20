import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainImage", "thumbnail"]
  static values = { currentIndex: Number }

  switch(event) {
    const button = event.currentTarget
    const index = parseInt(button.dataset.index)
    const fullUrl = button.dataset.fullUrl

    this.currentIndexValue = index
    this.updateGallery(fullUrl)
  }

  next() {
    this.currentIndexValue = (this.currentIndexValue + 1) % this.thumbnailTargets.length
    const nextThumbnail = this.thumbnailTargets[this.currentIndexValue]
    this.updateGallery(nextThumbnail.dataset.fullUrl)
  }

  previous() {
    this.currentIndexValue = (this.currentIndexValue - 1 + this.thumbnailTargets.length) % this.thumbnailTargets.length
    const prevThumbnail = this.thumbnailTargets[this.currentIndexValue]
    this.updateGallery(prevThumbnail.dataset.fullUrl)
  }

  updateGallery(fullUrl) {
    if (!this.hasMainImageTarget) return

    // 如果地址没变，不执行更新
    if (this.mainImageTarget.src === fullUrl) return

    // 使用 CSS 过渡而非 setTimeout 延迟，减少闪烁
    // 预加载图片以平滑切换
    const tempImage = new Image()
    tempImage.onload = () => {
      this.mainImageTarget.src = fullUrl
      this.mainImageTarget.style.opacity = "1"
    }
    
    this.mainImageTarget.style.opacity = "0.7" // 稍微降低透明度，保持可见性
    tempImage.src = fullUrl

    // 更新缩略图样式 (如果存在)
    if (this.hasThumbnailTarget) {
      this.thumbnailTargets.forEach((thumb, i) => {
        if (i === this.currentIndexValue) {
          thumb.classList.add("border-blue-600", "shadow-blue-100")
          thumb.classList.remove("border-slate-200")
          // Scroll into view if needed
          thumb.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' })
        } else {
          thumb.classList.remove("border-blue-600", "shadow-blue-100")
          thumb.classList.add("border-slate-200")
        }
      })
    }
  }
}
