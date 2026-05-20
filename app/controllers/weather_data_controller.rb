class WeatherDataController < ApplicationController
  layout "dashboard"

  def index
    @locations = Location.order(:name)
    @location  = Location.find_by(id: params[:location_id]) || @locations.first

    if @location
      @date_from = params[:date_from].present? ? Date.parse(params[:date_from]) : Date.current - 30
      @date_to   = params[:date_to].present?   ? Date.parse(params[:date_to])   : Date.current

      @readings = @location.weather_readings
        .where(date: @date_from..@date_to)
        .order(date: :desc)

      @total_gdd    = @readings.sum { |r| daily_gdd(r) }.round(1)
      @total_precip = @readings.sum { |r| r.precip.to_f }.round(2)
      @avg_high     = @readings.map { |r| r.max_temperature.to_f }.then { |v| v.any? ? (v.sum / v.size).round(1) : nil }
      @avg_low      = @readings.map { |r| r.min_temperature.to_f }.then { |v| v.any? ? (v.sum / v.size).round(1) : nil }
    end
  end

  private

  def daily_gdd(r)
    return 0 unless r.max_temperature && r.min_temperature
    tmax = [r.max_temperature.to_f, 86].min
    tmin = [r.min_temperature.to_f, 50].max
    [(tmax + tmin) / 2.0 - 50, 0].max
  end
end
