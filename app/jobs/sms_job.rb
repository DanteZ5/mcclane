class SmsJob < ApplicationJob
  queue_as :default

  # def perform(message_id)
  def perform(template_id, colevent_id, query: true)
    t = Template.find(template_id)
    c = Colevent.find(colevent_id)
    return if query && c.safe != 'pending' # casse l'execution de la suite

    account_sid = ENV["account_sid"]
    auth_token = ENV["auth_token"]
    @client = Twilio::REST::Client.new account_sid, auth_token
    message = Message.create(content: t.content, destination: "outbound", phone_number: c.collaborator.phone_pro, colevent_id: c.id)
    to = message.phone_number


    if t.order == 1
      # call
      url = "https://www.mcclane.tech/api/v1/templates/#{t.id}/voice.xml"
      @client.calls.create(
        url: url,
        to: to,
        from: '+33644603214'
      )
    else
      # SMS
      body = message.content
      @client.messages.create(
        body: body,
        to: to,
        from: "+33644603214")
    end

  end
end

