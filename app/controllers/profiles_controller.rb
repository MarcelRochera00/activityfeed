class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show, :edit, :update ]
  before_action :authorize_edit!, only: [ :edit, :update ]

  def show
    @is_profile = current_user == @user
    @activities = @user.activities
      .preload(:user, :tags, :likes, :activityable, :rich_text_body, :comments)
      .with_attached_preview_image
      .order(published_at: :desc)
    @username = current_user.username

    if params[:q].present?
      @activities = @activities.where("LOWER(title) LIKE ?", "%#{params[:q].downcase}%")
    end

    @pagy, @activities = pagy(@activities, limit: 10)
    @completed_goals = @user.goals.completed.order(completed_at: :desc)
    @active_goals = @user.goals.active.order(created_at: :desc) if @is_profile

    respond_to do |format|
      format.html
      format.turbo_stream if params[:page].present?
    end
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path(@user.username), notice: "Profile updated!"
    else
      flash.now[:alert] = "Failed to update profile. Please check the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end

  def authorize_edit!
    unless @user == current_user
      redirect_to profile_path(@user.username), alert: "You can't edit someone else's profile."
    end
  end

  def profile_params
    params.require(:user).permit(:username, :description, :location, :profile_image)
  end
end
