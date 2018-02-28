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

  class Scope < Scope
    def resolve
      scope
    end
  end
end
