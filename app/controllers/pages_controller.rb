class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :subscription, :create, :thanks]

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

  def subscription
    @collaborator = Collaborator.new

  end

  def create
    collaborator = Collaborator.new(collab_params)
    user = User.where(email: "demo@lewagon.org").first
    collaborator.email = "#{collaborator.first_name}@lewagon.org"
    collaborator.user_id = user.id
    collaborator.country = "France"
    collaborator.city = "Paris"
    collaborator.save
    redirect_to thanks_path
  end

  def thanks
  end

  private

  def collab_params
    #white list
    params.require(:collaborator).permit(:first_name, :last_name, :phone_pro)
  end
end
