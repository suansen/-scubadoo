class BookingsController < ApplicationController
  def new
    raise
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.new(booking_params)
    @booking.listing = @listing
    @booking.user = current_user
    @booking.costs = @booking.listing.price * ( @booking.no_of_divers || 0 )
    @booking.status = "booked"
    if @booking.save
      redirect_to @booking
    else
      render "listings/show"
    end
  end

  def index
    @bookings = Booking.all
  end

  private

  def booking_params
    params.require(:booking).permit(:no_of_divers)
  end
end
