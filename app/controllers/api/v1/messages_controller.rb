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

      # on veut passer colevent concerne en 'safe' des qu'on reçoit le message
      unless @message.content.nil?
        ce = @message.colevent
        ce.update(safe: true, safe_time: Time.now)
      end
    end

    # render json: { ok: true }
    head :no_content
  end
end
