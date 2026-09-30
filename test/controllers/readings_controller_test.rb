require "test_helper"

class ReadingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActivityBehavior

  setup do
    @user = users(:one)
    @reading = Reading.create!(
      title: "1984",
      author: "George Orwell",
      activity_attributes: { title: "Dystopia", user: @user }
    )
    @activity = @reading.activity
    @resource_name = "reading"
  end

  test "should create reading" do
    sign_in @user
    assert_difference([ "Reading.count", "Activity.count" ]) do
      post readings_url, params: {
        reading: {
          title: "Animal Farm",
          author: "George Orwell",
          activity_attributes: { title: "Political Fable" }
        }
      }
    end
    assert_redirected_to profile_path(@user.username)
  end
end
