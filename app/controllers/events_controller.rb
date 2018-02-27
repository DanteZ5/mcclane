class EventsController < ApplicationController
  before_action :set_event, only: [:show, :archive]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.name = "#{Time.now}"
    @event.status = "ongoing"

    if @event.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def show
  end

  def archive
    @event.status = "over"
  end

  private

  def event_params
    params.require(:event).permit(:name, :status, :end_date)
  end

  def set_event
    @event = Event.find(params[:id])
  end

end
