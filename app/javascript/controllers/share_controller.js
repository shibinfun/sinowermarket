import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["success", "button"]
  static values = {
    title: String,
    url: String,
    text: String
  }

  share(event) {
    event.preventDefault()

    const shareData = {
      title: this.titleValue,
      text: this.textValue,
      url: this.urlValue || window.location.href
    }

    if (navigator.share) {
      navigator.share(shareData)
        .then(() => this.showSuccess())
        .catch((error) => {
          if (error.name !== 'AbortError') {
            this.copyToClipboard()
          }
        })
    } else {
      this.copyToClipboard()
    }
  }

  copyToClipboard() {
    const url = this.urlValue || window.location.href
    navigator.clipboard.writeText(url).then(() => {
      this.showSuccess()
    }).catch(err => {
      console.error('Could not copy text: ', err)
    })
  }

  showSuccess() {
    if (this.hasSuccessTarget) {
      this.successTarget.classList.remove('hidden')
      setTimeout(() => {
        this.successTarget.classList.add('hidden')
      }, 2000)
    }
  }
}
