module ActivityBehavior
  extend ActiveSupport::Concern

  included do
    # These tests will be injected into any class that includes this module

    # Security and Guest Blocks
    test "shared: guest should be redirected from new to sign in" do
      get send("new_#{@resource_name}_url")
      assert_redirected_to new_user_session_path
    end

    test "shared: guest should be redirected from edit to sign in" do
      get send("edit_#{@resource_name}_url", @activity)
      assert_redirected_to new_user_session_path
    end

    # Ownership Authorization
    test "shared: should not allow unauthorized user to edit activity" do
      other_user = users(:two)
      sign_in other_user

      get send("edit_#{@resource_name}_url", @activity)
      assert_redirected_to feed_path
      follow_redirect!
      assert_match "You are not authorized", response.body
    end

    # Slug History Redirect
    test "shared: should redirect from old slug to new slug" do
      sign_in @user
      old_slug = @activity.slug

      # Change title to trigger slug update
      patch send("#{@resource_name}_url", @activity), params: {
        @resource_name => {
          activity_attributes: {
            id: @activity.id,
            title: "New Updated Title For Slug"
          }
        }
      }

      @activity.reload
      new_slug = @activity.slug
      assert_not_equal old_slug, new_slug

      # Visiting old slug should redirect to new slug (301)
      get send("#{@resource_name}_path", old_slug)
      assert_response :moved_permanently
      assert_redirected_to send("#{@resource_name}_path", new_slug)
    end

    # Sad Path UI (Validation Failures)
    test "shared: should render edit with errors on failed update" do
      sign_in @user
      patch send("#{@resource_name}_url", @activity), params: {
        @resource_name => {
          activity_attributes: {
            id: @activity.id,
            title: "" # Invalid: Title required
          }
        }
      }
      assert_response :unprocessable_entity
      assert_match "Failed to update", response.body
    end

    # Orphan Cleanup (Database Hygiene)
    test "shared: should destroy activity and associated records" do
      sign_in @user

      # Add a comment and a like to verify cleanup
      @activity.comments.create!(user: @user, body: "Cleanup test")
      @activity.likes.create!(user: @user)

      assert_difference([ "Activity.count", "Comment.count", "Like.count" ], -1) do
        delete send("#{@resource_name}_url", @activity)
      end
    end
  end
end
