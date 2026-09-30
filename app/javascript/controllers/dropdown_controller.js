import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.classList.toggle("show")
    
    // Close other dropdowns
    document.querySelectorAll('.dropdown-content.show').forEach(menu => {
      if (menu !== this.menuTarget) {
        menu.classList.remove('show')
      }
    })
  }

  // Close when clicking outside
  connect() {
    this.closeHandler = (event) => {
      if (!this.element.contains(event.target)) {
        this.menuTarget.classList.remove("show")
      }
    }
    document.addEventListener("click", this.closeHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.closeHandler)
  }
}
