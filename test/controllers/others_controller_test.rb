require "test_helper"

class OthersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActivityBehavior

  setup do
    @user = users(:one)
    @other = Other.create!(
      activity_attributes: { title: "Simple Post", user: @user }
    )
    @activity = @other.activity
    @resource_name = "other"
  end

  test "should create other activity" do
    sign_in @user
    assert_difference([ "Other.count", "Activity.count" ]) do
      post others_url, params: {
        other: {
          activity_attributes: { title: "Another Post", body: "Content here." }
        }
      }
    end
    assert_redirected_to profile_path(@user.username)
  end
end
