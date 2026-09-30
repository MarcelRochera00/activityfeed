require "test_helper"

class SetlistFmServiceTest < ActiveSupport::TestCase
  test "search_artists returns formatted artists" do
    fake_body = {
      artist: [
        { name: "Radiohead", mbid: "123-abc" },
        { name: "The Radio Dept.", mbid: "456-def" }
      ]
    }.to_json

    stub_request(:get, /api.setlist.fm\/rest\/1.0\/search\/artists/)
      .to_return(status: 200, body: fake_body, headers: { "Content-Type" => "application/json" })

    # Stub the method on the actual credentials object
    results = nil
    Rails.application.credentials.define_singleton_method(:setlist_fm) { { api_key: "dummy" } }

    begin
      results = SetlistFmService.search_artists("Radiohead")
    ensure
      # Cleanup
      class << Rails.application.credentials; remove_method :setlist_fm; end rescue nil
    end

    assert_equal 2, results.count
    assert_equal "Radiohead", results.first[:name]
  end

  test "search_concerts returns formatted setlist data" do
    fake_body = {
      setlist: [
        {
          venue: { name: "MSG", city: { name: "New York" } },
          tour: { name: "A Moon Shaped Pool" },
          sets: {
            set: [
              { song: [ { name: "Burn the Witch" }, { name: "Daydreaming" } ] }
            ]
          }
        }
      ]
    }.to_json

    stub_request(:get, /api.setlist.fm\/rest\/1.0\/search\/setlists/)
      .to_return(status: 200, body: fake_body, headers: { "Content-Type" => "application/json" })

    result = nil
    Rails.application.credentials.define_singleton_method(:setlist_fm) { { api_key: "dummy" } }

    begin
      result = SetlistFmService.search_concerts("Radiohead", "2024-05-19")
    ensure
      class << Rails.application.credentials; remove_method :setlist_fm; end rescue nil
    end

    assert_equal "MSG, New York", result[:venue]
    assert_equal [ "Burn the Witch", "Daydreaming" ], result[:tracklist]
  end
end
