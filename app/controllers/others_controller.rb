class OthersController < ApplicationController
  before_action :authenticate_user!

  include ActivityActions

  private

  def other_params
    params.require(:other).permit(
      activity_attributes: [ :id, :title, :body, :preview_image, tag_ids: [] ]
    )
  end
end
