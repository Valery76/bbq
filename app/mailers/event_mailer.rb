class EventMailer < ApplicationMailer
  # Письмо о новой подписке для автора события
  def subscription(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    mail to: event.user.email, subject: "Новая подписка на #{event.title}"
  end

  # Письмо о новом комментарии на заданный email
  def comment(event, comment, email)
    @comment = comment
    @event = event

    mail to: email, subject: "Новый комментарий @ #{event.title}"
  end

  def photo(event, photo, email)
    @event = event
    @photo = photo

    f = photo.photo.file
    @filename = f.filename
    content = Rails.env.production? ? f.read : f.to_file.read
    attachments.inline[@filename] = content

    mail to: email, subject: "Новая фотография @ #{event.title}"
  end
end
