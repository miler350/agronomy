class WeatherDataController < ApplicationController
  layout "dashboard"

  def index
    @locations = Location.order(:name)
    @location = Location.find_by(id: params[:location_id]) || Location.first
    @readings = @location.weather_readings.order(date: :desc).limit(60) if @location
  end
end
