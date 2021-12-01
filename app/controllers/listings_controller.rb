class ListingsController < ApplicationController
  # skip_before_action: authenticate_user!
  before_action :find_listing, only: [:show, :edit, :destroy]

  def index_trips
    @trips = Listing.where(category: "trip")
    # authorize @trips
  end

  def index_courses
    @courses = Listing.where(category: "course")
    # authorize @courses
  end

  def show
    @booking = Booking.new
    # authorize @booking if current_user == @booking.user
  end

  private

  def find_listing
    @listing = Listing.find(params[:id])
  end
end
