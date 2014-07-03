module ApplicationHelper
  def can_edit user
    true if (current_user == user || current_user.admin?) && current_page?(user_path(user))
  end

  def current_month
    Date::MONTHNAMES[Date.today.month]
  end
end
