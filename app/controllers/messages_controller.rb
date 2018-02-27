class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    account_sid = ENV["account_sid"] # Your Account SID from www.twilio.com/console
    auth_token = ENV["auth_token"]   # Your Auth Token from www.twilio.com/console
    body = params[:message][:question_content]
    to = params[:message][:phone_number]

    @client = Twilio::REST::Client.new account_sid, auth_token

    message = @client.messages.create(
        body: body,
        to: to,    # Replace with your phone number
        from: "+33644603214")  # Replace with your Twilio number
  end
end
