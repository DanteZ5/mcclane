class EventsController < ApplicationController
  before_action :set_event, only: [:show, :archive, :status_change, :close, :edit_messages]
  def index
    @events = policy_scope(Event)

    # @events = Event.select { |c| c.user == current_user }
    ev = Event.arel_table
    events = Event.where(ev[:user_id].eq(current_user.id))
    @events = events.order(:status, :updated_at).reverse
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
      # Si save, cree plusieurs instances template
      message_content = params[:event][:template][:description]
      Template.create(content: message_content, event: @event, slot: 0, order: 0)
      Template.create(content: "You have just received an alert text message. Please answer the message", event: @event, slot: 1, order: 1)
      Template.create(content: "IMPORTANT, Answer '1' if you're safe", event: @event, slot: 3, order: 2)
      # answers
      Template.create(content: "Thank you, we're glad to know you're safe", event: @event, slot: 0, order: 3)
      Template.create(content: "We just received your message. If you're safe, send 1. If you have any trouble, please call 911. We will contact you as soon as possible", event: @event, slot: 0, order: 4)

      # ne target que les collabs selectionnes
      areas = params[:area]
      collaborators = policy_scope(Collaborator)
      conditions = "continent IN (:areas) OR country IN (:areas) OR city IN (:areas)"
      collaborators = collaborators.where(conditions, areas: areas)

      # on itere sur collab, on cree les instances messages, on planifie les jobs
      collaborators.each do |collaborator|
        # cree plusieurs instances Colevent
        colevent = Colevent.create(collaborator: collaborator, event: @event, safe: "pending")
        # cree plusieurs instances messages (pour chaque colevent)
        @event.templates.each do |t|
          unless (collaborator.phone_pro == 'stop' || t.order > 2)
            SmsJob.set(wait: t.slot.minutes).perform_later(t.id, colevent.id)
          end
        end
      end

      # on renvoie vers le monitoring
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
    safe = @event.colevents.where(safe: 'safe').count
    suspect = @event.colevents.where(safe: 'suspect').count
    total_collaborators = @event.collaborators.count

    @template_labels = {1 => "Phone call after 1 min", 2 => "SMS sent after 3 min"}
    @templates = @event.templates.where(order: [1, 2]).order(:order)

    if total_collaborators == 0
      redirect_to new_event_path
    else
      @suspect_percentage = (suspect * 100) / total_collaborators
      @safe_percentage = safe * 100 / total_collaborators
      @unsafe_percentage = 100 - @suspect_percentage - @safe_percentage
    end
  end

  def archive
    @event.status = "over"
  end

  # a quoi sert cette feature ?
  def specific_sms
  message_content = params[:event][:template][:description]
  @message = Message.create(content: message_content,
                            colevent: c,
                            phone_number: c.collaborator.phone_pro,
                            destination: 'outbound')
  @message.send_sms unless message[:phone_number] == 'stop'
  # n'envoie pas a la seed
  end

  def close
    authorize @event
    @event.update(status: 'closed', end_date: Time.now)
    redirect_to events_path
  end

  def edit_messages
    authorize @event
    @event.templates.each_with_index do |t, i|
      t.update(content: params[:event][:templates_attributes]["#{i}"]["content"])
    end

    redirect_to event_path(@event)
  end

  private

  def event_params
    params.require(:event).permit(:name, :status, :end_date)
  end

  def set_event
    @event = Event.find(params[:id])
  end

end
