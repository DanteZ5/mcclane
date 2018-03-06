class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def guide
    open_events = current_user.events.where(status: 'ongoing')
    unless open_events.count == 0
      last_event = open_events.last
      redirect_to event_path(last_event)
    else
      redirect_to new_event_path
    end
  end


end
