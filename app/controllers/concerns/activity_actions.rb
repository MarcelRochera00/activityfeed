module ActivityActions
  extend ActiveSupport::Concern

  included do
    before_action :set_activity, only: [ :show, :edit, :update, :destroy ]
    before_action :authorize_activity, only: [ :edit, :update, :destroy ]
    before_action :set_available_tags, only: [ :new, :create, :edit, :update ]
  end

  def show
    if params[:slug] != @activity.slug
      return redirect_to @activity.specific_path, status: :moved_permanently
    end
    instance_variable_set("@#{resource_name}", @activity.activityable)
  end

  def new
    instance_variable_set("@#{resource_name}", model_class.new)
    @resource = instance_variable_get("@#{resource_name}")
    @resource.build_activity
  end

  def create
    @resource = model_class.new(resource_params)
    @resource.activity.user = current_user if @resource.activity

    if @resource.save
      redirect_to profile_path(current_user.username), notice: "#{resource_name.humanize} activity published!"
    else
      flash.now[:alert] = "Failed to publish #{resource_name.humanize} activity. Please check the errors below."
      instance_variable_set("@#{resource_name}", @resource)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    instance_variable_set("@#{resource_name}", @activity.activityable)
  end

  def update
    @resource = @activity.activityable

    if @resource.update(resource_params)
      redirect_to profile_path(current_user.username), notice: "#{resource_name.humanize} activity updated!"
    else
      flash.now[:alert] = "Failed to update #{resource_name.humanize} activity. Please check the errors below."
      instance_variable_set("@#{resource_name}", @resource)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy
    redirect_to profile_path(current_user.username), notice: "#{resource_name.humanize} deleted!"
  end

  private

  def model_class
    controller_name.classify.constantize
  end

  def resource_name
    controller_name.singularize
  end

  def set_activity
    # FriendlyId to find act (handles history/redirects)
    @activity = Activity.friendly.find(params[:slug]) rescue nil

    # Safety check: If it found an activity but it's the wrong type for this controller,
    # it means params[:slug] is the ID of a specific resource (Concert, Hike...)
    if @activity && @activity.activityable_type != model_class.name
      @activity = nil
    end

    # Fallback: Try finding by the activityable ID (for forms/updates using Concert IDs)
    unless @activity
      @activity = Activity.find_by(
        activityable_type: model_class.name,
        activityable_id: params[:slug]
      )
    end

    raise ActiveRecord::RecordNotFound, "Couldn't find Activity with slug or activityable_id='#{params[:slug]}'" unless @activity
  end

  def authorize_activity
    unless @activity.user == current_user
      redirect_to feed_path, alert: "You are not authorized to perform this action."
    end
  end

  def set_available_tags
    @available_tags = Tag.all
  end

  def resource_params
    send("#{resource_name}_params")
  end
end
