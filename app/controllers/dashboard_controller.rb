class DashboardController < ApplicationController
  layout "dashboard"

  def index
    @rows = PlantingEvent.includes(field: :location, field_observations: :growth_stage)
      .joins(:field)
      .order("fields.name")
      .map do |pe|
        result = GddCalculator.calculate(pe)
        { planting_event: pe, result: }
      end

    @last_synced = WeatherReading.maximum(:updated_at)

    @locations = Location.order(:name)
    @weather_location = params[:location_id] ? @locations.find_by(id: params[:location_id]) : @locations.first

    if @weather_location
      today = Date.current
      @today_reading = @weather_location.weather_readings.find_by(date: today)

      @forecast_readings = @weather_location.weather_readings
        .where(date: (today + 1)..(today + 14))
        .order(:date)

      @forecast_gdd = @forecast_readings.sum { |r| daily_gdd(r) }.round

      @chart_readings = @weather_location.weather_readings
        .where(date: (today + 1)..(today + 7))
        .order(:date)
    end
  end

  private

  def daily_gdd(reading)
    tmax = [reading.max_temperature.to_f, 86].min
    tmin = [reading.min_temperature.to_f, 50].max
    [(tmax + tmin) / 2.0 - 50, 0].max
  end
end
