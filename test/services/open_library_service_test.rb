require "test_helper"

class OpenLibraryServiceTest < ActiveSupport::TestCase
  test "search returns formatted books on success" do
    # Create a fake JSON response that looks like what the real API sends
    fake_response = {
      docs: [
        {
          title: "The Great Gatsby",
          author_name: [ "F. Scott Fitzgerald" ],
          isbn: [ "9780743273565" ],
          cover_i: 12345
        }
      ]
    }.to_json

    # Tell WebMock to intercept the request and return the fake response
    stub_request(:get, /openlibrary.org\/search.json/)
      .with(query: hash_including({ "title" => "Gatsby" }))
      .to_return(status: 200, body: fake_response, headers: { "Content-Type" => "application/json" })

    # Call our service
    results = OpenLibraryService.search("Gatsby")

    # Assertions: Did our service parse the fake data correctly?
    assert_equal 1, results.count
    book = results.first
    assert_equal "The Great Gatsby", book[:title]
    assert_equal "F. Scott Fitzgerald", book[:author]
    assert_equal "9780743273565", book[:isbn]
    assert_match "covers.openlibrary.org/b/id/12345-L.jpg", book[:cover_url]
  end

  test "search returns empty array when no books found" do
    stub_request(:get, /openlibrary.org\/search.json/)
      .to_return(status: 200, body: { docs: [] }.to_json, headers: { "Content-Type" => "application/json" })

    results = OpenLibraryService.search("NonExistentBook123")
    assert_equal [], results
  end

  test "search returns error hash when API fails" do
    stub_request(:get, /openlibrary.org\/search.json/)
      .to_return(status: 500, body: "Internal Server Error")

    result = OpenLibraryService.search("Gatsby")
    assert_equal "API search failed", result[:error]
    assert_equal 500, result[:status]
  end
end
