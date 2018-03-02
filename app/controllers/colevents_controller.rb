class ColeventsController < ApplicationController
  def update
    @colevent = Colevent.find(params[:id])
    authorize @colevent
    @colevent.safe = true
    @colevent.save
    redirect_to event_path(@colevent.event)
  end

  def mark_unsafe
    @colevent = Colevent.find(params[:colevent_id])
    authorize @colevent
    @colevent.safe = false
    @colevent.save
    redirect_to event_path(@colevent.event)
  end

end

