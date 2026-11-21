require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @activity = activities(:one)
  end
  test "don't save empty body comments" do
    comment = Comment.new(user_id: @user.id, activity_id: @activity.id, body: "")
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "don't save body full of spaces comments" do
    comment = Comment.new(user_id: @user.id, activity_id: @activity.id, body: "    ")
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "save valid comment" do
    comment = Comment.new(user_id: @user.id, activity_id: @activity.id, body: "valid body")
    assert comment.valid?
  end
end
