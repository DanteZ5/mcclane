class MessagePolicy < ApplicationPolicy

  def new?
   record.colevent.event.user == user
   # raise
  end

  def create?
    record.colevent.event.user == user
  end

  def show?
    record.colevent.event.user == user
  end

  def listen?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
