class MessagesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:listen]

  def new
    @message = Message.new
    @colevent = Colevent.find(params[:colevent_id])
    @colevent.event.user = current_user
    @message.colevent = @colevent
    # raise
    authorize @message
  end

  def show
    authorize @message
  end


  def create
    @message = Message.new(message_params)
    @message.colevent_id = params[:colevent_id]
    @message.destination = 'outbound'
    authorize @message
    @message.save
    @message.send_sms # methode dans model
  end

  def listen
    @message = params["Body"]
    account_sid = ENV["account_sid"] # Your Account SID from www.twilio.com/console
    auth_token = ENV["auth_token"]   # Your Auth Token from www.twilio.com/console
    # Initialize Twilio Client
    # @client = Twilio::REST::Client.new(account_sid, auth_token)

    # @call = @client.api.calls('CA42ed11f93dc08b952027ffbc406d0868').fetch

  end

  private

  def message_params
    #white list
    params.require(:message).permit(:content, :status, :type, :phone_number, :colevent_id)
  end
end
