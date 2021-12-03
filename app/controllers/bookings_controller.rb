class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :cancel, :export]
  before_action :authenticate_user!
  # only include in relevant controllers
  after_action :verify_authorized, except: [:index, :show, :new] , unless: :skip_pundit?

  def new
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.new
    @booking.no_of_divers = params[:no_of_divers] 
    @booking.costs = @booking.no_of_divers * @listing.price
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
    @markers =
      [{
        lat: @booking.listing.center.latitude,
        lng: @booking.listing.center.longitude,
        info_window: render_to_string(partial: "centers/info_window", locals: { center: @booking.listing.center })
      }]
  end

  def cancel
    if authorize(@booking)
      if @booking.status == "booked"
        @booking.status = "cancelled"
        @booking.save
      end
    end
    redirect_to @booking
  end

  def export
    if authorize(@booking)
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "booking", template: "bookings/show.html.erb"   # Excluding ".pdf" extension.
        end
      end
    end
    #redirect_to @booking
  end

  private

  def booking_params
    params.require(:booking).permit(:no_of_divers)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
