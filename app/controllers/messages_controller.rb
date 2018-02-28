class MessagesController < ApplicationController

  def new
    @message = Message.new
    @colevent = Colevent.find(params[:colevent_id])
  end

  def create
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
