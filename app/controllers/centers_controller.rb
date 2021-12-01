class CentersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :show, :index_trips, :index_courses, :manage_all], unless: :skip_pundit?

  def index
    if params[:query].nil? || params[:query].empty?
      @centers = Center.all
    else
      @centers = Center.where(location: params[:query])
    end
  end

  def show
    @center = Center.find(params[:id])
    @courses = @center.listings.where(category: "course").uniq(&:name)
    @dives = @center.listings.where(category: "trip").uniq(&:name)
  end

  def manage_all
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

  def delete
    raise
  end

  private

  def center_params
    params.require(:listing).permit(:name, :description, :address, :phone_number, :email, :location, :user, :photo)
  end
end
