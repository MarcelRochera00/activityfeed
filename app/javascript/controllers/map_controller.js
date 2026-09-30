import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    points: String
  }

  connect() {
    // Leaflet might be loading or already loaded
    if (typeof L !== 'undefined') {
      this.initMap()
    } else {
      let attempts = 0
      const interval = setInterval(() => {
        if (typeof L !== 'undefined') {
          clearInterval(interval)
          this.initMap()
        }
        if (++attempts > 20) clearInterval(interval)
      }, 100)
    }
  }

  initMap() {
    if (this.mapInitialized) return
    if (!this.hasPointsValue || !this.pointsValue) return
    if (!this.hasContainerTarget) return

    let points = []
    try {
      points = JSON.parse(this.pointsValue)
      // Handle double-encoded JSON string
      if (typeof points === 'string') {
        points = JSON.parse(points)
      }
    } catch (e) {
      console.error("MapController: Failed to parse points JSON", e)
      return
    }

    if (!Array.isArray(points) || points.length === 0) return

    // Convert points to Leaflet format [lat, lng]
    const path = points.map(p => [p.lat, p.lng])

    // Initialize map on the container target
    this.map = L.map(this.containerTarget, {
      zoomControl: false,
      attributionControl: false
    })

    // Add Tile Layer (Esri World Imagery for realistic visualization)
    L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
      attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
    }).addTo(this.map)

    // Optional: Add a subtle labels layer on top of satellite
    L.tileLayer('https://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}{r}.png', {
      pane: 'shadowPane',
      opacity: 0.7
    }).addTo(this.map)

    // Draw Polyline (Glowing effect for better visibility on satellite)
    const polyline = L.polyline(path, {
      color: '#22c55e', // Vibrant green
      weight: 5,
      opacity: 0.9,
      lineJoin: 'round'
    }).addTo(this.map)

    // Fit bounds
    this.map.fitBounds(polyline.getBounds(), { padding: [30, 30] })
    
    // Start Point (Pulsing-style circle)
    L.circleMarker(path[0], { 
      radius: 6, 
      color: '#fff', 
      fillColor: '#22c55e', 
      fillOpacity: 1, 
      weight: 3 
    }).addTo(this.map)

    // End Point (Custom SVG Pin)
    const endPoint = path[path.length - 1]
    const pinIcon = L.divIcon({
      html: `<svg width="30" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 0C7.58 0 4 3.58 4 8C4 13.54 12 24 12 24C12 24 20 13.54 20 8C20 3.58 16.42 0 12 0Z" fill="#ef4444"/>
              <circle cx="12" cy="8" r="3" fill="white"/>
            </svg>`,
      className: '',
      iconSize: [30, 40],
      iconAnchor: [15, 40]
    })
    
    L.marker(endPoint, { icon: pinIcon }).addTo(this.map)

    // Fix rendering issues
    setTimeout(() => {
      this.map.invalidateSize()
    }, 150)

    this.mapInitialized = true
  }
}
