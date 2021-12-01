class CentersController < ApplicationController
  def index
    if params[:location].present?
      @centers = Center.by_location(params[:location])
    else
      @centers = Center.all
    end
  end

  def show
    @center = Center.find(params[:id])
    @courses = @center.listings.where(category: "course").uniq(&:name)
    @dives = @center.listings.where(category: "trip").uniq(&:name)
  end
end
