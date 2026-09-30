import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["artistInput", "artistDropdown", "dateInput", "concertContainer", "concertItems", "tracklistInput", "venueInput"]

    connect() {
        console.log("Concert search controller connected!")
    }

    search() {
        const query = this.artistInputTarget.value

        if (query.length < 2) {
            this.artistDropdownTarget.innerHTML = ""
            this.artistDropdownTarget.style.display = "none"
            return
        }

        fetch("/concerts/search_artists?q=" + encodeURIComponent(query))
            .then(response => response.json())
            .then(artists => {
                let html = ""
                for (let i = 0; i < artists.length; i++) {
                    html += `<div class="tag-dropdown-item" data-name="${artists[i].name}" data-action="click->concert-search#select">${artists[i].name}</div>`
                }
                this.artistDropdownTarget.innerHTML = html
                this.artistDropdownTarget.style.display = html ? "block" : "none"
            })
    }

    select(event) {
        this.artistInputTarget.value = event.currentTarget.dataset.name
        this.artistDropdownTarget.innerHTML = ""
        this.artistDropdownTarget.style.display = "none"
        this.findConcert() // Trigger concert search after selection
    }

    findConcert() {
        const artist = this.artistInputTarget.value
        const date = this.dateInputTarget.value

        if (!artist || !date) return

        console.log(`Searching concert for ${artist} on ${date}...`)

        fetch(`/concerts/search_concerts?artist=${encodeURIComponent(artist)}&date=${encodeURIComponent(date)}`)
            .then(response => response.json())
            .then(data => {
                console.log("Concert data received:", data)
                if (!data.venue) {
                    this.concertContainerTarget.style.display = "none"
                    return
                }

                // Update hidden inputs for submission
                this.venueInputTarget.value = data.venue
                this.tracklistInputTarget.value = JSON.stringify(data.tracklist)

                let html = `
                    <div class="concert-item selected" data-action="click->concert-search#selectConcert">
                        <div class="concert-dot"></div>
                        <div class="concert-info">
                            <span class="concert-name">${data.tour || artist}</span>
                            <span class="concert-meta">${artist} · ${data.venue}</span>
                        </div>
                    </div>
                `

                this.concertItemsTarget.innerHTML = html
                this.concertContainerTarget.style.display = "block"
            })
            .catch(error => {
                console.error("Error fetching concert:", error)
            })
    }

    selectConcert(event) {
        const items = this.concertItemsTarget.querySelectorAll(".concert-item")
        items.forEach(item => item.classList.remove("selected"))
        event.currentTarget.classList.add("selected")
    }
}