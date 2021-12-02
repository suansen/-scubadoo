class CentersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized, except: [:index, :show, :manage_centers], unless: :skip_pundit?

  def index
    if params[:location].present?
      @centers = Center.by_location(params[:location])
    else
      @centers = Center.all
    end
    @markers = @centers.geocoded.map do |center|
      {
        lat: center.latitude,
        lng: center.longitude,
        info_window: render_to_string(partial: "info_window", locals: { center: center })
      }
    end
  end

  def show
    @center = Center.find(params[:id])
    @courses = @center.listings.where(category: "course").uniq(&:name)
    @dives = @center.listings.where(category: "trip").uniq(&:name)
    @markers =
      [{
        lat: @center.latitude,
        lng: @center.longitude
      }]
  end

  def manage_centers
    @centers = policy_scope(Center)
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

  def center_params
    params.require(:listing).permit(:name, :description, :address, :phone_number, :email, :location, :user, :photo)
  end
end
