class CentersController < ApplicationController
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

  private

  def center_params
    params.require(:listing).permit(:name, :description, :address, :phone_number, :email, :location, :user, :photo)
  end
end
