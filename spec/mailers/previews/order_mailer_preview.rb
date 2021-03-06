# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def send_confirmation
    order = Order.find(10)
    OrderMailer.send_confirmation(order)
  end
end
