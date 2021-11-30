class ListingsController < ApplicationController
  def index_trips
    @trips = Listing.where(category: "trip")
  end

  def index_courses
    @courses = Listing.where(category: "course")
  end
end
