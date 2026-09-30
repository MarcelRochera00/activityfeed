require "test_helper"

class ConcertsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActivityBehavior

  setup do
    @user = users(:one)
    @tag = tags(:one)

    @concert = Concert.create!(
      artist: "Daft Punk",
      date: Date.today,
      activity_attributes: {
        title: "Alive 2007",
        user: @user
      }
    )

    @activity = @concert.activity
    @resource_name = "concert"
  end

  test "should create concert" do
    sign_in @user
    assert_difference([ "Concert.count", "Activity.count" ]) do
      post concerts_url, params: {
        concert: {
          artist: "Radiohead",
          date: Date.today,
          activity_attributes: {
            title: "OK Computer Live",
            body: "In Rainbows style."
          }
        }
      }
    end
    assert_redirected_to profile_path(@user.username)
  end
end
