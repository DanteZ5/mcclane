class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def guide
    last_event = current_user.events.last

    if last_event.status == 'ongoing'
      redirect_to event_path(last_event)
    else
      redirect_to new_event_path
    end
  end


end
