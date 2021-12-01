class ListingsController < ApplicationController
  before_action :find_listing, only: [:show, :edit, :destroy]

  def index_trips
    @trips = Listing.where(category: "trip")
  end

  def index_courses
    @courses = Listing.where(category: "course")
  end

  def show
    @booking = Booking.new
  end

  private

  def find_listing
    @listing = Listing.find(params[:id])
  end
end
