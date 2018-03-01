class ColeventsController < ApplicationController
  def update
    @colevent = Colevent.find(params[:id])
    authorize @colevent
    @colevent.safe = true
    @colevent.save
    redirect_to event_path(@colevent.event)
  end
end
