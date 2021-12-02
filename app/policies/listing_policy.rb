class ListingPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    record.user == user
  end

  def update?
    record.user == user
  end

  def manage_listings?
    record.user == user
  end
end
