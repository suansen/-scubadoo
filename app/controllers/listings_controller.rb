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

  def listing_params
    params.require(:listing).permit(:category, :name, :description, :price, :description, :date, :start_time, :duration, :dive_count, :max_divers, :center, :photo)
  end
end
