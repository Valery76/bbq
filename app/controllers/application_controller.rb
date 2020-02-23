class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Настройка для работы девайза при правке профиля юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Хелпер метод, доступный во вьюхах
  helper_method :current_user_can_edit?, :user_can_subscribe?

  # Настройка для девайза — разрешаем обновлять профиль, но обрезаем
  # параметры, связанные со сменой пароля.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  def current_user_can_edit?(obj)
    user_signed_in? && (
      obj.user == current_user ||
      obj.try(:event).try(:user) == current_user
    )
  end

  def user_can_subscribe?(event)
    !user_signed_in? ||
    (current_user != event.user &&
      event.subscriptions.where(user: current_user).blank?)
  end
end
