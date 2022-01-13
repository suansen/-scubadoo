class ListingsController < ApplicationController
  before_action :find_listing, only: [:show, :edit, :destroy, :edit, :update]
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
      @markers << {
        lat: list.latitude,
        lng: list.longitude,
        info_window: render_to_string(partial: "info_window", locals: { list: list })
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
    @center = Center.find(params[:center_id])
    if authorize @center
      @listing = Listing.new
    else
      redirect_to root_path
    end
  end

  def create
    @center = Center.find(params[:center_id])
    @listing = Listing.new(listing_params)
    @listing.center = @center
    if authorize @center
      if @listing.save
        redirect_to manage_listings_path(@center)
      else
        render "new"
      end
    else
      redirect_to root_path
    end
  end

  def edit
    @center = @listing.center
    redirect_to root_path unless authorize @center
  end

  def update
    @center = @listing.center
    if authorize @center
      if @listing.update(listing_params)
        redirect_to manage_listings_path(@center)
      else
        render "edit"
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    @listing.destroy if authorize @listing.center
    redirect_to manage_listings_path(@listing.center)
  end

  private

  def find_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:category, :name, :description, :price, :description, :date, :start_time, :duration, :dive_count, :max_divers, :latitude, :longitude, :center, :photo)
  end
end
