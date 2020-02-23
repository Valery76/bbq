class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  with_options unless: -> { user.present? } do |subscr|
    subscr.validates :user_name, presence: true
    subscr.validates :user_email, presence: true,
      format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/
    subscr.validates :user_email,
      uniqueness: { scope: :event_id,
        message: I18n.t('models.subscription.already_subscribed')}
  end

  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }
  validate :user_cannot_subscribe_their_own_event, if: -> { user.present? }

  # переопределяем метод, если есть юзер, выдаем его имя,
  # если нет -- дергаем исходный переопределенный метод
  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  # переопределяем метод, если есть юзер, выдаем его email,
  # если нет -- дергаем исходный переопределенный метод
  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  private

  def user_cannot_subscribe_their_own_event
    if user == event.user
      errors.add(:user, I18n.t('models.subscription.user_cannot_subscribe'))
    end
  end
end
