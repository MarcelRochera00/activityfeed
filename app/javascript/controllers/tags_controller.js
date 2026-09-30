import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "dropdown", "selectedContainer", "hiddenContainer" ]
  static values = {
    available: Array,
    fieldName: String
  }

  connect() {
    this.selectedIds = new Set()
    this.initializeExistingTags()
  }

  initializeExistingTags() {
    // 1. Find any existing hidden inputs and add their values to our Set
    this.hiddenContainerTarget.querySelectorAll("input").forEach(input => {
      this.selectedIds.add(parseInt(input.value))
    })

    // 2. Ensure existing visual tags have the correct action to be removed
    this.selectedContainerTarget.querySelectorAll(".remove-tag").forEach(btn => {
      if (!btn.dataset.action) {
        btn.dataset.action = "click->tags#remove"
      }
    })
  }

  filter(event) {
    const query = event.target.value.toLowerCase()
    
    if (query.length === 0) {
      this.hideDropdown()
      return
    }

    const filtered = this.availableValue.filter(tag => 
      tag.name.toLowerCase().includes(query) && !this.selectedIds.has(tag.id)
    )

    if (filtered.length > 0) {
      this.renderDropdown(filtered)
    } else {
      this.hideDropdown()
    }
  }

  select(event) {
    const id = parseInt(event.currentTarget.dataset.id)
    const name = event.currentTarget.dataset.name
    
    if (this.selectedIds.has(id)) return

    this.addTag(id, name)
    this.inputTarget.value = ""
    this.hideDropdown()
    this.inputTarget.focus()
  }

  remove(event) {
    const id = parseInt(event.currentTarget.dataset.id)
    this.selectedIds.delete(id)
    
    // Remove visual tag
    event.currentTarget.closest(".selected-tag").remove()
    
    // Remove hidden input
    const hiddenInput = this.hiddenContainerTarget.querySelector(`input[value='${id}']`)
    if (hiddenInput) hiddenInput.remove()
  }

  // Private helpers
  addTag(id, name) {
    this.selectedIds.add(id)

    // Create visual tag
    const tagEl = document.createElement("div")
    tagEl.className = "selected-tag"
    tagEl.innerHTML = `
      #${name}
      <span class="remove-tag" data-action="click->tags#remove" data-id="${id}">
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </span>
    `
    this.selectedContainerTarget.appendChild(tagEl)

    // Create hidden input for Rails
    const hidden = document.createElement("input")
    hidden.type = "hidden"
    hidden.name = this.fieldNameValue
    hidden.value = id
    this.hiddenContainerTarget.appendChild(hidden)
  }

  renderDropdown(tags) {
    this.dropdownTarget.innerHTML = ""
    tags.slice(0, 8).forEach(tag => {
      const item = document.createElement("div")
      item.className = "tag-dropdown-item"
      item.innerText = `#${tag.name}`
      item.dataset.id = tag.id
      item.dataset.name = tag.name
      item.dataset.action = "click->tags#select"
      this.dropdownTarget.appendChild(item)
    })
    this.dropdownTarget.style.display = "block"
  }

  hideDropdown() {
    this.dropdownTarget.style.display = "none"
  }

  // Handle clicking outside to close
  disconnect() {
    this.hideDropdown()
  }
}
