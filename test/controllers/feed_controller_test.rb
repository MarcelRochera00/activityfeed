require "test_helper"

class FeedControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "should get index when authenticated" do
    sign_in @user
    get feed_path
    assert_response :success
  end

  test "feed should exclude current user's activities" do
    sign_in @user

    # Create an activity for the current user
    my_activity = Activity.create!(title: "My Private Activity", user: @user, activityable: Other.create!)

    # Create an activity for another user
    other_user = users(:two)
    other_activity = Activity.create!(title: "Someone Else's Activity", user: other_user, activityable: Other.create!)

    get feed_path

    assert_select "h2.card-title", text: /#{other_activity.title}/
    assert_select "h2.card-title", { count: 0, text: /#{my_activity.title}/ }, "Should not show current user's activity"
  end

  test "feed search should filter results" do
    sign_in @user
    other_user = users(:two)

    Activity.create!(title: "Match This", user: other_user, activityable: Other.create!)
    Activity.create!(title: "Ignore This", user: other_user, activityable: Other.create!)

    get feed_path(q: "Match")

    assert_select "h2.card-title", text: /Match This/
    assert_select "h2.card-title", count: 0, text: /Ignore This/
  end

  test "should redirect to login when unauthenticated" do
    get feed_path
    assert_redirected_to new_user_session_path
  end
end
