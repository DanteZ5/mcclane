class EventsController < ApplicationController
  before_action :set_event, only: [:show, :archive, :status_change]
  def index
    @events = policy_scope(Event)

    # @events = Event.select { |c| c.user == current_user }
    ev = Event.arel_table
    events = Event.where(ev[:user_id].eq(current_user.id))
    @events = events.order(:updated_at).reverse
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

      c = Collaborator.arel_table
      # collab = Collaborator.where(c[:user_id].eq(current_user.id))

      collaborators = Collaborator.where(
        (c[:continent].in(params[:continent])).
        or(c[:country].in(params[:country])).
        or(c[:city].in(params[:city])).
        and(c[:user_id].eq(current_user.id))
        ).distinct
      # collaborators = Collaborator.where(user_id: current_user, continent: params[:continent],country: params[:country], city: params[:city])


      collaborators.each do |collaborator|
        # cree plusieurs instances Colevent
        colevent = Colevent.create(collaborator: collaborator, event: @event, safe: "pending")
        # cree plusieurs instannces messages (pour chaque colevent)
        message = Message.create(content: message_content, colevent: colevent, phone_number: colevent.collaborator.phone_pro, destination: 'outbound')
        # message.send_sms unless message[:phone_number] == 'stop' # n'envoie pas a la seed

      end
      redirect_to event_path(@event)

    else
      render :new
    end
  end

  def show
    @message = Message.new
    authorize @event

    # permet de sortir colevents par priorites
    priorities = {'suspect'=>1, 'pending'=>2, 'safe'=>3}
    @colevents = @event.colevents.sort {|x, y| priorities[x.safe] <=> priorities[y.safe]}

    unsafe = @event.colevents.where(safe: 'pending').count
    suspect = @event.colevents.where(safe: 'suspect').count
    total_collaborators = @event.collaborators.count
    if total_collaborators == 0
      redirect_to new_event_path
    else
      @unsafe_percentage = (unsafe * 100) / total_collaborators
      @suspect_percentage = (suspect * 100) / total_collaborators
      @safe_percentage = 100 - @unsafe_percentage - @suspect_percentage
    end
  end

  def archive
    @event.status = "over"
  end

  def specific_sms
  message_content = params[:event][:template][:description]
  @message = Message.create(content: message_content, colevent: c, phone_number: c.collaborator.phone_pro, destination: 'outbound')
  @message.send_sms unless message[:phone_number] == 'stop' # n'envoie pas a la seed
  end

  private

  def event_params
    params.require(:event).permit(:name, :status, :end_date)
  end

  def set_event
    @event = Event.find(params[:id])
  end

end
