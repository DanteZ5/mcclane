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
          t = ce.event.templates.where(order: 4).first
          SmsJob.perform_later(t.id, ce.id)
        else
          ce.update(safe: 'suspect', safe_time: Time.now)
          t = ce.event.templates.where(order: 5).first
          SmsJob.perform_later(t.id, ce.id)
        end
        event = @message.colevent.event
        unsafe = event.colevents.where(safe: 'pending').count
        suspect = event.colevents.where(safe: 'suspect').count
        safe = event.colevents.where(safe: 'safe').count
        total_collaborators = event.colevents.count

        if total_collaborators == 0
          redirect_to new_event_path
        else
          @suspect_percentage = (suspect * 100) / total_collaborators
          @safe_percentage = (safe * 100) / total_collaborators
          @unsafe_percentage = 100 - @safe_percentage - @suspect_percentage
        end
          ActionCable.server.broadcast("event_#{@message.colevent.event.id}", {
            colevent_id: @message.colevent_id,
            safe: @message.colevent.safe,
            unsafe_percentage: @unsafe_percentage,
            suspect_percentage: @suspect_percentage,
            safe_percentage: @safe_percentage,
            employee_row_partial: ApplicationController.renderer.render(
              partial: "events/employee_row",
              locals: { colevent: ce }
            )
          })
        # render json: { ok: true }
        end
    end
    head :no_content
  end
end
