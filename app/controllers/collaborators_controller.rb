class CollaboratorsController < ApplicationController
  skip_after_action :verify_authorized, only: [:count, :import, :create]
  after_action :verify_policy_scoped, only: [:count, :import, :create]

  def new
    @collaborator = Collaborator.new
    authorize @collaborator
  end

  def index
    @events = policy_scope(Event)
    ev = Collaborator.arel_table
    @collaborators = Collaborator.where(ev[:user_id].eq(current_user.id))
  end

  def import
    collaborators = policy_scope(Collaborator)
    Collaborator.import(params[:file], current_user.id)
    redirect_to collaborators_path, notice: "Activity Data imported!"
  end

  def count
    areas = params[:areas]

    collaborators = policy_scope(Collaborator)
    conditions = "continent IN (:areas) OR country IN (:areas) OR city IN (:areas)"
    collaborators_count = collaborators.where(conditions, areas: areas).count

    render json: { count: collaborators_count }
  end

  def show
    @collaborator = Collaborator.find(params[:id])
  end

  def edit
    @collaborator = Collaborator.find(params[:id])
    authorize @collaborator
  end

  def create
    user = current_user
    @collaborator = Collaborator.new(collaborator_params)
    @collaborator.user_id = user.id
    if @collaborator.save
      ev = Collaborator.arel_table
      @collaborators = Collaborator.where(ev[:user_id].eq(current_user.id))
      authorize @collaborator
      render :index
    else
      render :new
    end
  end

  def update
    @collaborator = Collaborator.find(params[:id])
    authorize @collaborator
    @collaborator.update(collaborator_params)
    redirect_to collaborators_path
  end

  def destroy
     @collaborator = Collaborator.find(params[:id])
     authorize @collaborator
     @collaborator.destroy
     redirect_to collaborators_path
  end

  private

  def collaborator_params
    collaborators = policy_scope(Collaborator)
    # authorize @collaborator
    params.require(:collaborator).permit(:email, :phone_pro, :first_name, :last_name, :continent, :country, :city)
  end

end
