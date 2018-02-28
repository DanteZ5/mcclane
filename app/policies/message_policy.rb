class MessagePolicy < ApplicationPolicy
  def new?
   # @colevent.event.user == user
   record.colevent.event.user == user
  end

  def create?
    record.colevent.event.user == user
  end

  def show?
    record.colevent.event.user == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
