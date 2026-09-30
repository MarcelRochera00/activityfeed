import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["searchInput", "resultsContainer", "resultsList", "titleInput", "authorInput", "isbnInput", "coverUrlInput", "selectedBookPanel"]

    connect() {
        this.searchMode = "title"
    }

    setMode(event) {
        const buttons = this.element.querySelectorAll(".search-option")
        buttons.forEach(btn => btn.classList.remove("active"))
        event.currentTarget.classList.add("active")

        this.searchMode = event.currentTarget.dataset.mode
        this.searchInputTarget.placeholder = `Search for a book by ${this.searchMode.toLowerCase()}...`
    }

    search() {
        const query = this.searchInputTarget.value
        if (!query) return

        this.resultsListTarget.innerHTML = "<div class='book-item'>Searching...</div>"
        this.resultsContainerTarget.style.display = "block"

        fetch(`/readings/search_books?q=${encodeURIComponent(query)}&mode=${this.searchMode}`)
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => { throw new Error(err.error || 'Search failed') })
                }
                return response.json()
            })
            .then(data => {
                this.renderResults(data.books)
            })
            .catch(error => {
                console.error("Error searching books:", error)
                this.resultsListTarget.innerHTML = `<div class='book-item' style='color: #ef4444;'>Error: ${error.message}</div>`
            })
    }

    renderResults(books) {
        if (!books || books.length === 0) {
            this.resultsListTarget.innerHTML = "<div class='book-item'>No books found.</div>"
            return
        }

        let html = ""
        books.forEach((book, index) => {
            html += `
                <div class="book-item" 
                     data-action="click->book-search#select" 
                     data-title="${this.escapeHtml(book.title || '')}" 
                     data-author="${this.escapeHtml(book.author || '')}" 
                     data-isbn="${this.escapeHtml(book.isbn || '')}"
                     data-cover="${book.cover_url || ''}">
                    <div class="book-dot"></div>
                    <div class="book-info">
                        <span class="book-name">${book.title}</span>
                        <span class="book-meta">${book.author || 'Unknown Author'} · ${book.isbn || 'No ISBN'}</span>
                    </div>
                </div>
            `
        })
        this.resultsListTarget.innerHTML = html
    }

    select(event) {
        const item = event.currentTarget
        const title = item.dataset.title
        const author = item.dataset.author
        const isbn = item.dataset.isbn
        const coverUrl = item.dataset.cover

        // Update hidden inputs for saving data
        this.titleInputTarget.value = title
        this.authorInputTarget.value = author
        this.isbnInputTarget.value = isbn
        if (this.hasCoverUrlInputTarget) {
            this.coverUrlInputTarget.value = coverUrl
        }

        // Highlight selected item in search results
        const items = this.resultsListTarget.querySelectorAll(".book-item")
        items.forEach(i => i.classList.remove("selected"))
        item.classList.add("selected")

        // Update the "Selected Book" panel with the API cover
        this.updateSelectedPanel(title, author, isbn, coverUrl)
    }

    updateSelectedPanel(title, author, isbn, coverUrl) {
        if (!this.hasSelectedBookPanelTarget) return

        let html = `
            <div class="activity-details-card" style="margin-top: 1.5rem; border-color: #f97316;">
                <div style="display: flex; gap: 1.5rem; align-items: start;">
                    <div class="detail-group" style="flex-shrink: 0; width: 100px;">
                        <span class="detail-label">Cover</span>
                        ${coverUrl ? `<img src="${coverUrl}" class="book-cover-mini" style="width: 100%; height: auto; border-radius: 8px;">` :
                `<div class="book-cover-mini" style="width: 100%; height: 150px; display: flex; align-items: center; justify-content: center; background: #f1f5f9; color: #94a3b8; border-radius: 8px;">No Cover</div>`}
                    </div>
                    <div style="flex-grow: 1; display: flex; flex-direction: column; gap: 0.75rem;">
                        <div class="detail-group">
                            <span class="detail-label">Title</span>
                            <span class="detail-value">${title}</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">Author</span>
                            <span class="detail-value">${author || 'Unknown Author'}</span>
                        </div>
                        <div class="detail-group">
                            <span class="detail-label">ISBN</span>
                            <span class="detail-value">${isbn || 'No ISBN'}</span>
                        </div>
                    </div>
                </div>
            </div>
        `
        this.selectedBookPanelTarget.innerHTML = html
        this.selectedBookPanelTarget.style.display = "block"
    }

    escapeHtml(text) {
        const div = document.createElement('div')
        div.textContent = text
        return div.innerHTML
    }
}
