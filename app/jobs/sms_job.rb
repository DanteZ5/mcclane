class SmsJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    account_sid = ENV["account_sid"] # Your Account SID from www.twilio.com/console
    auth_token = ENV["auth_token"]   # Your Auth Token from www.twilio.com/console
    @client = Twilio::REST::Client.new account_sid, auth_token

    body = message.content
    to = message.phone_number
    @client.messages.create(
      body: body,
      to: to,
      from: "+33644603214")
      # from: message.colevent.event.user.company)

  end
end
