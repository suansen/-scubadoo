class CentersController < ApplicationController
  def index
    if params[:location].present?
      @centers = Center.by_location
    else
      @centers = Center.all
    end
  end

  def show
    @center = Center.find(params[:id])
    @courses = @center.listings.where(category: "course").uniq(&:name)
    @dives = @center.listings.where(category: "trip").uniq(&:name)
  end

  private

  def center_params
    params.require(:listing).permit(:name, :description, :address, :phone_number, :email, :location, :user, :photo)
  end
end
