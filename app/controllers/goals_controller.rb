class GoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal, only: [ :destroy ]

  def new
    @goal = current_user.goals.new
  end

  def create
    @goal = current_user.goals.new(goal_params)

    if @goal.save
      redirect_to profile_path(current_user.username), notice: "Goal set! Track your progress on your profile."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    username = @goal.user.username
    @goal.destroy
    redirect_to profile_path(username), notice: "Goal deleted."
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:description, :target_value, :unit, :activity_type)
  end
end
