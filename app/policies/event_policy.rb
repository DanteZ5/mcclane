class EventPolicy < ApplicationPolicy

  def new?
    record.user == user
  end

  def create?
    record.user == user
  end

  def show?
    record.user == user
  end

  def archive?
    record.user == user
  end

  def close?
    record.user == user
  end

  def edit_messages?
    record.user == user
  end


  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
