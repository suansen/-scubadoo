class CenterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    true
  end

  def create?
    record.user == user
  end

  def update?
    record.user == user
  end

  def manage_all?
    record.user == user
  end
end
