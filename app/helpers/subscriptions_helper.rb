module SubscriptionsHelper
  def user_can_subscribe?(event)
    !user_signed_in? ||
    (current_user != event.user &&
      event.subscriptions.where(user: current_user).blank?)
  end
end
