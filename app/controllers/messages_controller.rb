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
    @message.save!
    @message.send_sms # methode dans model
    redirect_to event_path(@message.colevent.event)
  end

  private

  def message_params
    #white list
    params.require(:message).permit(:content, :status, :type, :phone_number, :colevent_id)
  end
end
