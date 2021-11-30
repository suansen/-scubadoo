class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  def new
    raise
  end

  def create
    raise
  end

  def index
    @bookings = Booking.all
  end

  def show
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
