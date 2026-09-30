class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity
  before_action :set_comment, only: [ :destroy ]

  def create
    @comment = @activity.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        flash.now[:notice] = "Comment was successfully added."
        format.turbo_stream
        format.html { redirect_to @activity.specific_path, notice: "Comment was successfully added." }
      else
        flash.now[:alert] = "Error adding comment."
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment-form-#{@activity.id}", partial: "comments/form", locals: { activity: @activity, comment: @comment }) }
        format.html { redirect_to @activity.specific_path, alert: "Error adding comment." }
      end
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        flash.now[:notice] = "Comment was successfully deleted."
        format.turbo_stream
        format.html { redirect_to @activity.specific_path, notice: "Comment was successfully deleted." }
      end
    else
      redirect_to @activity.specific_path, alert: "Not authorized to delete this comment."
    end
  end

  private

  def set_activity
    @activity = Activity.friendly.find(params[:activity_slug])
  end

  def set_comment
    @comment = @activity.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
