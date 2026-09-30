require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @other_user = users(:two)
    @activity_one = activities(:one) # Activity One
    @activity_two = activities(:two)   # Activity Two
    # Initial state has NO likes
  end


  test "should create and delete a like of any activity when authenticated" do
    sign_in @user

    assert_nil @user.likes.find_by(activity: @activity_two) # Activity was not liked
    post activity_like_path(@activity_two)
    like_check = @user.likes.find_by(activity: @activity_two) # Activity was liked by userone
    post activity_like_path(@activity_two)
    unlike_check = @user.likes.find_by(activity: @activity_two) # Activity was unliked by userone

    assert_not_nil like_check
    assert_nil unlike_check
  end

  test "should not create and delete a like of any activity when unauthenticated" do
    assert_no_difference("Like.count") do
      post activity_like_path(@activity_two)
    end

    assert_redirected_to new_user_session_path
  end

  test "should create and delete a like and respond with a turbo stream" do
    sign_in @user

    post activity_like_path(@activity_two), as: :turbo_stream # Establish interaction as a turbo stream request

    assert_response :success

    assert_equal "text/vnd.turbo-stream.html", response.media_type # Check turbo-stream header
    assert_match(/<turbo-stream action="replace" target="like_#{@activity_two.id}">/, response.body) # Make sure it's the appropiate header
  end
end
