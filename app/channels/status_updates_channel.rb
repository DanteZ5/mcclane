class StatusUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "event_#{params[:event_id]}"

  end


end
