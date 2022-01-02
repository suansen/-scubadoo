class PagesController < ApplicationController
  def home
    @locations = []
    center_array = Center.all.uniq { |center| center.location.strip }
    center_array.each do |center|
      @locations << center.location.strip
    end

    @interests = []
    Interest.all.each do |interest|
      @interests << interest
    end
  end
end
