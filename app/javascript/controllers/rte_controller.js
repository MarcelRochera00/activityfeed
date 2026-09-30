import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "editor", "hiddenInput", "fileInput" ]

  connect() {
    // Initial sync if needed
    if (this.hasHiddenInputTarget && this.hasEditorTarget) {
      this.editorTarget.innerHTML = this.hiddenInputTarget.value
    }
  }

  execCommand(event) {
    event.preventDefault()
    const command = event.currentTarget.dataset.command
    const value = event.currentTarget.dataset.value || null
    
    document.execCommand(command, false, value)
    this.updateHiddenInput()
    this.editorTarget.focus()
  }

  insertImage(event) {
    event.preventDefault()
    this.fileInputTarget.click()
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.editorTarget.focus()
      document.execCommand('insertImage', false, e.target.result)
      this.updateHiddenInput()
    }
    reader.readAsDataURL(file)
  }

  updateHiddenInput() {
    this.hiddenInputTarget.value = this.editorTarget.innerHTML
  }
}
