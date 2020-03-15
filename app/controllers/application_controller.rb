class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Настройка для работы девайза при правке профиля юзера
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Хелпер метод, доступный во вьюхах
  helper_method :current_user_can_edit?

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

  protected

  def notify_subscribers(event, property)
    all_emails =
      event.subscriptions.pluck(:user_email).compact +
      event.subscribers.pluck(:email) +
      [event.user.email] - [property.user&.email]

    case property.class.name
    when 'Comment'
      all_emails.each do |mail|
        EventMailer.comment(event, property, mail).deliver_now
      end
    when 'Photo'
      all_emails.each do |mail|
        EventMailer.photo(event, property, mail).deliver_now
      end
    end
  end
end
