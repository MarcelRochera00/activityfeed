module ApplicationHelper
  def avatar_url(user, size: 160)
    if user.profile_image.attached?
      url_for(user.profile_image)
    else
      name = CGI.escape(user.username.presence || user.email.split("@").first)
      "https://ui-avatars.com/api/?name=#{name}&size=#{size}&background=1e293b&color=ffffff&bold=true&format=png"
    end
  end
end
