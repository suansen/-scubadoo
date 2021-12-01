class ListingsController < ApplicationController
  before_action :find_listing, only: [:show, :edit, :destroy]

  def index_trips

    if params[:location].present?
      @trips = Listing.by_location(params[:location]).by_trips
    else
      @trips = Listing.by_trips
    end
  end

  def index_courses
    if params[:location].present?
      @courses = Listing.by_location(params[:location]).by_courses
    else
      @courses = Listing.by_courses
    end
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
