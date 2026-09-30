class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:id])
    current_user.follow(@user)
    @user.reload

    respond_to do |format|
      format.html { redirect_to profile_path(@user.username), notice: "Started following #{@user.username}" }
      format.turbo_stream { flash.now[:notice] = "Started following #{@user.username}" }
    end
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    @user.reload

    respond_to do |format|
      format.html { redirect_to profile_path(@user.username), notice: "Unfollowed #{@user.username}" }
      format.turbo_stream { flash.now[:notice] = "Unfollowed #{@user.username}" }
    end
  end
end
