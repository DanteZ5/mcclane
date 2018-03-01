class EventsController < ApplicationController
  before_action :set_event, only: [:show, :archive]
  def index
    @events = policy_scope(Event)
  end

  def new
    @event = Event.new
    @event.user = current_user
    authorize @event

    # methode d'extraction des collabs associees a l'entreprise
    my_collabs = Collaborator.select { |c| c.user == current_user }

    # continents = Collaborator.distinct.pluck(:continent)
    # ancienne methode ci dessus
    continents = my_collabs.pluck(:continent).uniq
    Struct.new("Continent", :continent, :name)
    @continents = continents.map do |continent|
      Struct::Continent.new(continent, continent)
    end

    countries = my_collabs.pluck(:country).uniq
    Struct.new("Country", :country, :name)
    @countries = countries.map do |country|
      Struct::Country.new(country, country)
    end

    cities = my_collabs.pluck(:city).uniq
    Struct.new("City", :city, :name)
    @cities = cities.map do |city|
      Struct::City.new(city, city)
    end

  end

  def create
    # Cree une instance Event
    @event = Event.new(event_params)
    @event.name = "#{Time.now}"
    @event.status = "ongoing"
    @event.user = current_user
    authorize @event
    if @event.save
      # Si save, cree une instance template
      message_content = params[:event][:template][:description]
      template = Template.create(content: message_content, event: @event, slot: 5, order: 0)
      collaborators = Collaborator.where(user_id: current_user, continent: params[:continent2],country: params[:Country2], city: params[:city2])
      collaborators.each do |collaborator|
        # cree plusieurs instances Colevent
        colevent = Colevent.create(collaborator: collaborator, event: @event, safe: false)
        # cree plusieurs instannces messages (pour chage colevent)
        message = Message.create(content: message_content, colevent: colevent, phone_number: colevent.collaborator.phone_pro, destination: 'outbound')
        message.send_sms if false # change manuellement true / false pour activer / desactiver
      end
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def show
    authorize @event
    unsafe = @event.colevents.where(safe: false).count
    total_collaborators = @event.collaborators.count
    @unsafe_percentage = (unsafe * 100) / total_collaborators
    @safe_percentage = 100 - @unsafe_percentage
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
