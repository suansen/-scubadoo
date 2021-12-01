class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    # record.user == user
    true
  end

  def show?
    record.user == user
  end

  def create?
    record.user == user
  end
end
