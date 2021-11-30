class ListingsController < ApplicationController
  def index_trips
    @trips = Listing.where(category: "Diving")
  end
end
