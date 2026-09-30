require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should get show profile when authenticated" do
    sign_in @user

    # Can view own profile
    get profile_path(@user.username)
    assert_response :success

    # Can view another user's profile
    get profile_path(@other_user.username)
    assert_response :success
  end

  test "should get edit for own profile when authenticated" do
    sign_in @user
    get edit_profile_path(@user.username)
    assert_response :success
  end

  test "should redirect and block trying to get edit for another user's profile" do
    sign_in @user
    get edit_profile_path(@other_user.username)

    # The request gets blocked and user is redirected to other_user's profile page
    assert_redirected_to profile_path(@other_user.username)
  end

  test "should update own profile successfully with precise database validation" do
    sign_in @user
    new_location = "Toronto, Canada"
    new_description = "This is a new description."

    # Submit profile update request
    patch update_profile_path(@user.username), params: {
      user: {
        location: new_location,
        description: new_description
      }
    }

    @user.reload

    # Verify profile update completed
    assert_equal new_location, @user.location
    assert_equal new_description, @user.description

    assert_redirected_to profile_path(@user.username)
  end

  test "should redirect and block updating another user's profile" do
    sign_in @user

    # Try to update @other_user's profile from @user.
    patch update_profile_path(@other_user.username), params: {
      user: { location: "Toronto, Canada" }
    }

    # Verify profile update NOT completed
    assert_nil @other_user.reload.location

    assert_redirected_to profile_path(@other_user.username)
  end

  test "should reject profile update with invalid attributes (too long description)" do
    sign_in @user

    invalid_description = "a" * 201
    patch update_profile_path(@user.username), params: {
      user: { description: invalid_description }
    }

    # Verify @user's profile update NOT completed
    assert_nil @user.reload.description

    assert_response :unprocessable_entity
  end

  test "should reject profile update with invalid attributes (too long username)" do
    sign_in @user
    original_username = @user.username

    invalid_username = "a" * 21
    patch update_profile_path(@user.username), params: {
      user: { username: invalid_username }
    }

    # Verify @user's profile update NOT completed
    assert_equal original_username, @user.reload.username

    assert_response :unprocessable_entity
  end
end
