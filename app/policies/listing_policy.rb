class ListingPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    record.user == user
  end

  def create?
    record.user == user
  end

  def edit?
    record.user == user
  end

  def update?
    record.user == user
  end

  def manage_listings?
    record.user == user
  end
end
