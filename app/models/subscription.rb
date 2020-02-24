class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  with_options unless: -> { user.present? } do
    validates :user_name, presence: true
    validates :user_email, presence: true, format: URI::MailTo::EMAIL_REGEXP
    validates :user_email, uniqueness: { scope: :event_id }
    validates :user_email, exclusion: { in: User.all.map(&:email) }
  end

  with_options if: -> { user.present? } do
    validates :user, uniqueness: { scope: :event_id }
    validate :user_cannot_subscribe_their_own_event
  end

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
      errors.add(:user)
    end
  end
end
