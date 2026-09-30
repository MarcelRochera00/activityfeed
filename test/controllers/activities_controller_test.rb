require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @activity = activities(:one) # Represents an 'Other' activity
  end

  test "should get new activity selection grid when authenticated" do
    sign_in @user
    get new_activity_path
    assert_response :success
  end

  test "should redirect activity show page to specific path with found status (302)" do
    sign_in @user
    get activity_path(@activity)

    # Verify standard redirect to the polymorphic specific path
    assert_redirected_to @activity.specific_path
    assert_response :found
  end

  test "should redirect activity show page to new path with moved_permanently status (301) when using old slug history" do
    sign_in @user

    # Create a dynamic activity inside the test transaction to ensure FriendlyId callbacks populate the history tables
    other_resource = Other.create!
    activity = Activity.create!(
      title: "Initial Title",
      user: @user,
      activityable: other_resource
    )
    old_slug = activity.slug

    # Update the title to trigger FriendlyId history slug generation
    activity.update!(title: "New Title")
    activity.reload

    new_slug = activity.slug
    assert_not_equal old_slug, new_slug # Verify that the slug has changed

    # Request the activity show page using the OLD slug
    get activity_path(old_slug)

    # Verify it does an SEO-friendly 301 redirect to the new specific path
    assert_redirected_to activity.specific_path
    assert_response :moved_permanently
  end
end
