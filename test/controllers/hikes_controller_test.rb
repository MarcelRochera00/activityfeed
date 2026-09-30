require "test_helper"

class HikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActivityBehavior # Injects shared security and behavior tests

  setup do
    @user = users(:one)
    @tag = tags(:one)

    @hike = Hike.create!(
      trail_name: "Initial Trail",
      activity_attributes: {
        title: "Initial Hike Title",
        user: @user,
        tag_ids: [ @tag.id ]
      }
    )

    # Required for ActivityBehavior shared tests
    @activity = @hike.activity
    @resource_name = "hike"
  end

  # --- Hike Specific Tests ---

  test "should create hike with valid attributes" do
    sign_in @user
    assert_difference([ "Hike.count", "Activity.count" ]) do
      post hikes_url, params: {
        hike: {
          trail_name: "Mount Whitney",
          activity_attributes: {
            title: "Summit Day",
            body: "The view was great.",
            tag_ids: [ @tag.id ]
          }
        }
      }
    end
    assert_redirected_to profile_path(@user.username)
  end

  test "should remove tags correctly on update" do
    sign_in @user
    assert_equal 1, @hike.activity.tags.count

    patch hike_url(@hike.activity), params: {
      hike: {
        activity_attributes: {
          id: @hike.activity.id,
          tag_ids: [] # Remove all tags
        }
      }
    }

    @hike.reload
    assert_equal 0, @hike.activity.tags.count
  end
end
