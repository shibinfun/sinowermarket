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
    // Update main image with a simple fade effect
    this.mainImageTarget.style.opacity = "0"
    
    setTimeout(() => {
      this.mainImageTarget.src = fullUrl
      this.mainImageTarget.style.opacity = "1"
    }, 200)

    // Update thumbnail styles
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
