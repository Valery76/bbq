module EventMailerHelper
  def event_over?(event)
    event.datetime < Time.current
  end
end
