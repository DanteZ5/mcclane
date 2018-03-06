class SmsJob < ApplicationJob
  queue_as :default

  # def perform(message_id)
  def perform(template_id, colevent_id)
    t = Template.find(template_id)
    c = Colevent.find(colevent_id)
    return unless c.safe == 'pending' # casse l'execution de la suite

    # cree l'instance message
    message = Message.create(content: t.content, destination: "outbound", phone_number: c.collaborator.phone_pro, colevent_id: c.id)
    # message = Message.find(message_id)
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
