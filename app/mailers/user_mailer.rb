class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'
  def new_event(order_id, email)
    @order_url = order_url(order_id)
    mail(to: email, subject: t(:new_event_subject))
  end
end
