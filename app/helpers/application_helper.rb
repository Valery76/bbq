module ApplicationHelper
  # Возвращает путь к аватарке данного юзера
  def user_avatar(user)
    asset_path('user.png')
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def user_can_subscribe?(event)
    !user_signed_in? ||
    (current_user != event.user &&
      event.subscriptions.where(user: current_user).blank?)
  end
end
