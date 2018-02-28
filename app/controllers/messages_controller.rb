class MessagesController < ApplicationController


  def new
    @message = Message.new
    @colevent = Colevent.find(params[:colevent_id])
    @colevent.event.user = current_user
    @message.colevent = @colevent
    raise
    authorize @message
  end

  def show
    authorize @message
  end


  def create
    authorize @message
    @message = Message.new(message_params)
    @message.colevent_id = params[:colevent_id]
    @message.save
    @message.send_sms
  end

  private

  def message_params
    #white list
    params.require(:message).permit(:question_content, :status, :answer_content, :answer_time, :phone_number, :colevent_id)
  end
end
