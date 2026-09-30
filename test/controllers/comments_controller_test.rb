require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @other_user = users(:two)
    @activity = activities(:one)
    @comment = comments(:one)
  end

  test "should create a comment when authenticated" do
    sign_in @user
    comment_body = "This is the body of a test comment."

    post activity_comments_path(@activity), params: {
      comment: { body: comment_body }
    }
    new_comment = Comment.find_by(user: @user, activity: @activity, body: comment_body)

    assert_not_nil new_comment # Comment was created
    assert_equal comment_body, new_comment.body # Comment body is correct

    assert_redirected_to @activity.specific_path
  end

  test "should not create a comment when unauthenticated" do
    comment_body = "This is the body of a test comment."

    post activity_comments_path(@activity), params: {
      comment: { body: comment_body }
    }

    assert_nil Comment.find_by(body: comment_body) # Comment was not created

    assert_redirected_to new_user_session_path
  end

  test "should delete own comment when authenticated" do
    sign_in @user
    @comment.update!(user: @user)

    delete activity_comment_path(@activity, @comment)

    assert_nil Comment.find_by(id: @comment.id) # Comment was deleted

    assert_redirected_to @activity.specific_path
  end

  test "should not delete another user's comment" do
    sign_in @other_user
    @comment.update!(user: @user) # Comment belongs to user one
    @activity.update!(user: @user) # Activity belongs to user one

    delete activity_comment_path(@activity, @comment)

    assert_not_nil Comment.find_by(id: @comment.id) # Comment was not deleted

    assert_redirected_to @activity.specific_path
  end

  test "should create a comment via Turbo Stream with a flash notice" do
    sign_in @user
    comment_body = "Turbo Stream comment body!"

    post activity_comments_path(@activity), params: {
      comment: { body: comment_body }
    }, as: :turbo_stream

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type

    # Verify database insertion
    new_comment = Comment.find_by(user: @user, activity: @activity, body: comment_body)
    assert_not_nil new_comment

    # Verify that the response contains turbo-stream instructions to append comments_list and flash-container
    assert_match /turbo-stream action="append" target="comments_list"/, response.body
    assert_match /turbo-stream action="append" target="flash-container"/, response.body
    assert_match /Comment was successfully added./, response.body
  end

  test "should delete a comment via Turbo Stream with a flash notice" do
    sign_in @user
    @comment.update!(user: @user)

    delete activity_comment_path(@activity, @comment), as: :turbo_stream

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type

    # Verify database deletion
    assert_nil Comment.find_by(id: @comment.id)

    # Verify turbo-stream response instructions
    assert_match /turbo-stream action="remove" target="comment_#{@comment.id}"/, response.body
    assert_match /turbo-stream action="append" target="flash-container"/, response.body
    assert_match /Comment was successfully deleted./, response.body
  end
end
