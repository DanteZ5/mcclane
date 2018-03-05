class Api::V1::MessagesController < Api::V1::BaseController

  def listen
    # authorize @message
    @message = Message.new
    @message.content = params["Body"]
    @message.destination = 'inbound'
    @message.phone_number = params["From"]

    # fonction permettant de retrouver l'id colevent
    c = Collaborator.find_by(phone_pro: @message.phone_number)
    unless c.nil?
      colevents = Colevent.where(collaborator_id: c.id)
      colevent = colevents.last # on considere que seul le dernier event compte
      @message.colevent_id = colevent.id

      # sauvegarde de l'instance
      @message.save
      # msg = Message.last
      # ActionCable.server.broadcast("event_#{msg.colevent.event.id}", {colevent_id: msg.colevent_id})

      # on veut passer colevent concerne en 'safe' des qu'on reçoit le message
      unless @message.content.nil?
        ce = @message.colevent
        if @message.content == '1'
          ce.update(safe: 'safe', safe_time: Time.now)
        else
          ce.update(safe: 'suspect', safe_time: Time.now)
        end
      end
    end
      ActionCable.server.broadcast("event_#{@message.colevent.event.id}", {colevent_id: @message.colevent_id, safe: @message.colevent.safe})

    # render json: { ok: true }
    head :no_content
  end


end
