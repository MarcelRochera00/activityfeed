class SetlistFmService
  BASE_URL = "https://api.setlist.fm/rest/1.0"

  def self.search_artists(query)
    return [] if query.blank?

    response = get_request("/search/artists", { artistName: query, sort: "relevance" })

    if response.success?
      artists = JSON.parse(response.body)["artist"] || []
      artists.map { |a| { name: a["name"], mbid: a["mbid"] } }
    else
      []
    end
  end

  def self.search_concerts(artist, date)
    return {} if artist.blank? || date.blank?

    formatted_date = Date.parse(date).strftime("%d-%m-%Y") rescue date
    response = get_request("/search/setlists", { artistName: artist, date: formatted_date })

    if response.success?
      parse_setlist(response.body)
    else
      {}
    end
  end

  private

  def self.get_request(path, params)
    Faraday.get("#{BASE_URL}#{path}") do |req|
      req.params = params
      req.headers["x-api-key"] = Rails.application.credentials.setlist_fm[:api_key]
      req.headers["Accept"] = "application/json"
    end
  end

  def self.parse_setlist(body)
    setlists = JSON.parse(body)["setlist"] || []
    first = setlists.first
    return {} unless first

    songs = first.dig("sets", "set")&.flat_map { |s| s["song"].map { |song| song["name"] } } || []
    venue = first.dig("venue", "name")
    city  = first.dig("venue", "city", "name")
    tour  = first.dig("tour", "name")

    { venue: "#{venue}, #{city}", tracklist: songs, tour: tour }
  end
end
