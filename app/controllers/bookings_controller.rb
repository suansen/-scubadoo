class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # only include in relevant controllers
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_authorized, except: :show, unless: :skip_pundit?

  def new
    raise
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.new(booking_params)
    @booking.listing = @listing
    @booking.user = current_user
    @booking.costs = @booking.listing.price * (@booking.no_of_divers || 0 )
    @booking.status = "booked"
    if @booking.save
      redirect_to @booking
    else
      render "listings/show"
    end
    authorize @booking
  end

  def index
    @bookings = policy_scope(Booking)
    authorize @bookings
  end

  def show
    authorize @booking
  end

  private

  def booking_params
    params.require(:booking).permit(:no_of_divers)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
