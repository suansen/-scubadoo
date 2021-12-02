class ListingsController < ApplicationController
  before_action :find_listing, only: [:show, :edit, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :index_trips, :index_courses]
  after_action :verify_authorized, except: [:index, :show, :manage_listings, :index_trips, :index_courses], unless: :skip_pundit?

  def index_trips
    if params[:location].present?
      @trips = Listing.by_location(params[:location]).by_trips
    else
      @trips = Listing.by_trips
    end

    @markers = []
    @trips.each do |list|
      @markers << { lat: list.latitude, lng: list.longitude, info_window: render_to_string(partial: "info_window", locals: { list: list })
      }
    end
  end

  def index_courses
    if params[:location].present?
      @courses = Listing.by_location(params[:location]).by_courses
    else
      @courses = Listing.by_courses
    end
    @markers = []
    @courses.each do |list|
      @markers << { lat: list.latitude, lng: list.longitude, info_window: render_to_string(partial: "info_window", locals: { list: list })
      }
    end

  end

  def show
    @booking = Booking.new
    @center_markers = [{  lat: @listing.center.latitude,
                          lng: @listing.center.longitude }]
    @listing_markers = [{ lat: @listing.latitude,
                          lng: @listing.longitude }]
  end

  def manage_listings
    @center = Center.find(params[:center_id])
    @listings = @center.listings
  end

  def new
    raise
  end

  def create
    raise
  end

  def edit
    raise
  end

  def update
    raise
  end

  def destroy
    raise
  end

  private

  def find_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:category, :name, :description, :price, :description, :date, :start_time, :duration, :dive_count, :max_divers, :center, :photo)
  end
end
