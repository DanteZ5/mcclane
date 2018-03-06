class CollaboratorsController < ApplicationController
  skip_after_action :verify_authorized, only: [:count, :import]
  after_action :verify_policy_scoped, only: [:count, :import]

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
    # continents = params[:continents]
    # countries = params[:countries]
    # cities = params[:cities]
    areas = params[:areas]
    # filters = {}

    # filters[:continent] = continents if continents.present?
    # filters[:country] = countries if countries.present?
    # filters[:city] = cities if cities.present?

    # filters
    # => {
    #   continent: ["France", "Afrique"],
    #   country: ["Maroc"],
    #   city: ["Tokyo"]
    # }
    collaborators = policy_scope(Collaborator)
    # # => collaborators = Collaborator.where(user_id: current_user.id)
    # conditions = filters.map { |filter_name, values| "#{filter_name} IN (?)" }.join(" OR ")
    # # conditions
    # # => "continent IN ? OR country IN ? OR city in ?"
    # collaborators_count = collaborators.where(conditions, *filters.values).count
    conditions = "continent IN (:areas) OR country IN (:areas) OR city IN (:areas)"
    collaborators_count = collaborators.where(conditions, areas: areas).count

    render json: { count: collaborators_count }
  end

  def show
    # @collaborator = Collaborator.find(params[:id])
  end

end
