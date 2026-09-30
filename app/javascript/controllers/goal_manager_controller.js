import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "island" ]

  toggleDeleteMode(event) {
    event.preventDefault()

    const island = this.islandTarget
    island.classList.toggle("delete-mode")

    // Force-close the dropdown after the user clicks "Delete Goals".
    // The dropdown_controller uses the "show" CSS class to reveal the menu —
    // the previous code was removing "active" which did absolutely nothing!
    const menu = island.querySelector('[data-dropdown-target="menu"]')
    if (menu) menu.classList.remove("show")
  }
}
