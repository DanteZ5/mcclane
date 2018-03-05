class ColeventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    record.event.user == user
  end

  def mark_unsafe?
    update?
  end

  def mark_suspect?
    update?
  end

end
