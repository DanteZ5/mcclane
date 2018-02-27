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
    @event.user = current_user
    if @event.save
      collaborators = Collaborator.where(country: params[:event][:search][:country], city: params[:event][:search][:city])
      message = params[:event][:template][:content]
      template = Template.create(content: message, event: @event, slot: 5, order: 0)
      collaborators.each do |collaborator|
        colevent = Colevent.create(collaborator: collaborator, event: @event, safe: false)
        Message.create(question_content: message, colevent: colevent)
      end
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
