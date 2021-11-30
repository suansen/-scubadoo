class CentersController < ApplicationController
  def index
    @centers = Center.all
  end

  def show
    @center = Center.find(params[:id])
    @courses = @center.listings.where(category: "course").uniq(&:name)
    @dives = @center.listings.where(category: "Diving").uniq(&:name)
  end
end
