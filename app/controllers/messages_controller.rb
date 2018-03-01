class MessagesController < ApplicationController

  skip_before_action :authenticate_user!, only: :listen

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
    @message = Message.new
    @message.content = params["Body"]
    @message.colevent_id = 25
    @message.phone_number = params["From"]
    @message.save
    if @message.content == "1"
      @message.colevent.safe = true
      @message.colevent.save
      @message.colevent.safe_time = Time.now
    end
  end

  private

  def message_params
    #white list
    params.require(:message).permit(:content, :status, :type, :phone_number, :colevent_id)
  end
end
