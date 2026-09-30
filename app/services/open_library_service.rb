class OpenLibraryService
  BASE_URL = "https://openlibrary.org/search.json"
  USER_AGENT = "ActivityFeed/1.0 (contact: marcelrochera9@gmail.com)"

  def self.search(query, mode: "title")
    return [] if query.blank?

    response = Faraday.get(BASE_URL) do |req|
      case mode
      when "title"
        req.params["title"] = query
      when "author"
        req.params["author"] = query
      when "isbn"
        req.params["isbn"] = query
      else
        req.params["q"] = query
      end

      req.params["fields"] = "title,author_name,isbn,cover_i,key"
      req.headers["User-Agent"] = USER_AGENT
      req.headers["Accept"] = "application/json"
    end

    if response.success?
      parse_results(response.body)
    else
      { error: "API search failed", status: response.status }
    end
  rescue JSON::ParserError
    { error: "Invalid response from book API" }
  rescue StandardError => e
    { error: "Search error: #{e.message}" }
  end

  private

  def self.parse_results(body)
    books = JSON.parse(body)["docs"] || []
    books.take(10).map do |book|
      {
        title: book["title"],
        author: book["author_name"]&.join(", "),
        isbn: book["isbn"]&.first,
        cover_url: book["cover_i"] ? "https://covers.openlibrary.org/b/id/#{book["cover_i"]}-L.jpg" : nil
      }
    end
  end
end
