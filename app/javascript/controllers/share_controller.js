import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
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
        .then(() => console.log('Successful share'))
        .catch((error) => console.log('Error sharing', error))
    } else {
      // Fallback for browsers that don't support Web Share API
      this.showFallbackMenu()
    }
  }

  showFallbackMenu() {
    // Basic fallback: copy to clipboard or open a simple modal/dropdown
    // For now, let's just copy the URL to clipboard as a simple fallback
    const url = this.urlValue || window.location.href
    navigator.clipboard.writeText(url).then(() => {
      alert("Link copied to clipboard!")
    }).catch(err => {
      console.error('Could not copy text: ', err)
      alert("Please copy the URL manually: " + url)
    })
  }
}
