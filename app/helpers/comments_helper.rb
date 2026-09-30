module CommentsHelper
  def format_comment_date(datetime)
    return "" unless datetime

    local_date = datetime.in_time_zone.to_date
    current_date = Date.current

    if local_date == current_date
      "Today"
    elsif local_date.year != current_date.year
      local_date.strftime("%d/%m/%Y")
    else
      local_date.strftime("%d/%m")
    end
  end
end
