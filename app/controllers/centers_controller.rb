class CentersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :verify_authorized, except: [:index, :show, :manage_centers, :new], unless: :skip_pundit?

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
    @center = Center.new
  end

  def create
    @center = Center.new(center_params)
    @center.user = current_user
    if authorize @center
      if @center.save
        redirect_to @center
      else
        render "new"
      end
    else
      redirect_to root_path
    end
  end

  def edit
    @center = Center.find(params[:id])
    redirect_to root_path unless authorize @center
  end

  def update
    @center = Center.find(params[:id])
    if authorize @center
      if @center.update(center_params)
        redirect_to @center
      else
        render "edit"
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    @center = Center.find(params[:id])
    @center.destroy if authorize @center
    redirect_to manage_centers_path
  end

  private

  def center_params
    params.require(:center).permit(:name, :description, :address, :phone_number, :email, :location, :language, :user, :photo)
  end
end
