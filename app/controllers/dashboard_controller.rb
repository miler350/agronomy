class DashboardController < ApplicationController
  layout "dashboard"

  def index
    @rows = PlantingEvent.includes(field: [:location, :tags], field_observations: :growth_stage)
      .joins(:field)
      .order("fields.name")
      .map do |pe|
        result = GddCalculator.calculate(pe)
        { planting_event: pe, result: }
      end

    @last_synced   = WeatherReading.maximum(:updated_at)
    @growth_stages = GrowthStage.order(:crop_type, :position)
    @tags          = Tag.order(:name)

    @locations        = Location.order(:name)
    @weather_location = params[:location_id] ? @locations.find_by(id: params[:location_id]) : @locations.first
    @forecast_days    = [params[:forecast_days].to_i, 3].max
    @forecast_days    = [@forecast_days, 14].min
    @forecast_days    = 14 if @forecast_days == 0

    if @weather_location
      today = Date.current
      @today_reading = @weather_location.weather_readings.find_by(date: today)

      @forecast_readings = @weather_location.weather_readings
        .where(date: (today + 1)..(today + @forecast_days))
        .order(:date)

      @forecast_gdd = @forecast_readings.sum { |r| daily_gdd(r) }.round

      @chart_readings = @weather_location.weather_readings
        .where(date: (today + 1)..(today + @forecast_days))
        .order(:date)
    end
  end

  def export
    @rows = PlantingEvent.includes(field: :location, field_observations: :growth_stage)
      .joins(:field)
      .order("fields.name")
      .map do |pe|
        result = GddCalculator.calculate(pe)
        { planting_event: pe, result: }
      end

    respond_to do |format|
      format.csv do
        headers["Content-Disposition"] = "attachment; filename=\"fields_progress_#{Date.current}.csv\""
        headers["Content-Type"] = "text/csv"
        render plain: generate_csv(@rows)
      end
    end
  end

  private

  def daily_gdd(reading)
    tmax = [reading.max_temperature.to_f, 86].min
    tmin = [reading.min_temperature.to_f, 50].max
    [(tmax + tmin) / 2.0 - 50, 0].max
  end

  def generate_csv(rows)
    require "csv"
    CSV.generate do |csv|
      csv << ["Field", "Farm", "Location", "Hybrid", "Planted", "Accum. GDD",
              "Current Stage", "Next Stage", "GDD to Next", "Predicted Next Date", "Status"]
      rows.each do |row|
        pe     = row[:planting_event]
        result = row[:result]
        csv << [
          pe.field.name,
          pe.field.farm,
          pe.field.location.name,
          pe.product,
          pe.planted_on&.strftime("%Y-%m-%d"),
          result.calibrated_gdd.round,
          result.current_stage&.name,
          result.next_stage&.name,
          result.gdd_to_next.round,
          result.predicted_next_date&.strftime("%Y-%m-%d"),
          result.status.to_s.tr("_", " ")
        ]
      end
    end
  end
end
