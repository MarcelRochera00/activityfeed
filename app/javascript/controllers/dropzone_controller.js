import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "preview", "previewImage", "placeholder" ]

  connect() {
    this.displayPreview()
  }

  // Triggered when clicking the dropzone
  browse() {
    this.inputTarget.click()
  }

  // Triggered when a file is selected or dropped
  handleFile(event) {
    const file = event.target.files[0] || event.dataTransfer?.files[0]
    if (!file) return

    if (event.dataTransfer) {
      this.inputTarget.files = event.dataTransfer.files
    }

    this.showPreview(file)
  }

  // Drag & Drop event handlers
  dragover(event) {
    event.preventDefault()
    this.element.classList.add("dropzone--active")
  }

  dragleave() {
    this.element.classList.remove("dropzone--active")
  }

  drop(event) {
    event.preventDefault()
    this.element.classList.remove("dropzone--active")
    this.handleFile(event)
  }

  // Remove the image
  remove(event) {
    event.preventDefault()
    event.stopPropagation()
    this.inputTarget.value = ""
    this.hidePreview()
  }

  // Private helpers
  showPreview(file) {
    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewImageTarget.src = e.target.result
      this.displayPreview()
    }
    reader.readAsDataURL(file)
  }

  displayPreview() {
    if (this.previewImageTarget.src && !this.previewImageTarget.src.endsWith("#")) {
      this.previewTarget.classList.remove("hidden")
      this.placeholderTarget.classList.add("hidden")
    } else {
      this.hidePreview()
    }
  }

  hidePreview() {
    this.previewTarget.classList.add("hidden")
    this.placeholderTarget.classList.remove("hidden")
    this.previewImageTarget.src = ""
  }
}
