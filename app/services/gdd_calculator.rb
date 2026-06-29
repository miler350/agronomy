class GddCalculator
  BASE_TEMP = 50.0
  TEMP_CAP  = 86.0

  Result = Struct.new(
    :cumulative_gdd,
    :calibrated_gdd,
    :current_stage,
    :next_stage,
    :gdd_to_next,
    :predicted_next_date,
    :status,            # :on_track | :delayed | :ahead
    :uses_calendar_days,
    :days_from_planting,
    keyword_init: true
  )

  def self.calculate(planting_event)
    new(planting_event).calculate
  end

  def initialize(planting_event)
    @event    = planting_event
    @field    = planting_event.field
    @location = @field.location
  end

  def calculate
    if @event.crop_type == "soybean"
      calculate_soybean
    else
      calculate_corn
    end
  end

  private

  def calculate_corn
    readings = WeatherReading
      .where(location: @location)
      .where("date >= ?", @event.planted_on)
      .where("date <= ?", Date.current)
      .order(:date)

    raw_gdd    = readings.sum { |r| daily_gdd(r) }
    calibrated = raw_gdd - calibration_offset

    stages        = GrowthStage.where.not(gdd_threshold: nil).where(crop_type: "corn").order(:position)
    current_stage = stages.select { |s| s.gdd_threshold <= calibrated }.last
    next_stage    = stages.find   { |s| s.gdd_threshold >  calibrated }

    gdd_to_next         = next_stage ? (next_stage.gdd_threshold - calibrated).round(1) : 0
    predicted_next_date = next_stage ? predict_date(calibrated, next_stage.gdd_threshold) : nil

    Result.new(
      cumulative_gdd:      raw_gdd.round(1),
      calibrated_gdd:      calibrated.round(1),
      current_stage:       current_stage,
      next_stage:          next_stage,
      gdd_to_next:         gdd_to_next,
      predicted_next_date: predicted_next_date,
      status:              determine_status,
      uses_calendar_days:  false,
      days_from_planting:  nil
    )
  end

  def calculate_soybean
    days = (Date.current - @event.planted_on).to_i

    stages        = GrowthStage.where.not(days_threshold: nil).where(crop_type: "soybean").order(:position)
    current_stage = stages.select { |s| s.days_threshold <= days }.last
    next_stage    = stages.find   { |s| s.days_threshold >  days }

    days_to_next        = next_stage ? (next_stage.days_threshold - days) : 0
    predicted_next_date = next_stage ? (@event.planted_on + next_stage.days_threshold) : nil

    # Still accumulate raw GDD for informational display
    readings = WeatherReading
      .where(location: @location)
      .where("date >= ?", @event.planted_on)
      .where("date <= ?", Date.current)
      .order(:date)
    raw_gdd = readings.sum { |r| daily_gdd(r) }

    Result.new(
      cumulative_gdd:      raw_gdd.round(1),
      calibrated_gdd:      raw_gdd.round(1),
      current_stage:       current_stage,
      next_stage:          next_stage,
      gdd_to_next:         days_to_next,
      predicted_next_date: predicted_next_date,
      status:              :on_track,
      uses_calendar_days:  true,
      days_from_planting:  days
    )
  end

  def daily_gdd(reading)
    return 0 unless reading.max_temperature && reading.min_temperature
    tmax = [ reading.max_temperature.to_f, TEMP_CAP  ].min
    tmin = [ reading.min_temperature.to_f, BASE_TEMP ].max
    [ ((tmax + tmin) / 2.0) - BASE_TEMP, 0 ].max
  end

  def calibration_offset
    obs = @event.field_observations
      .includes(:growth_stage)
      .order(:observed_on)
      .last
    return 0.0 unless obs
    return 0.0 unless obs.growth_stage.gdd_threshold

    predicted = obs.growth_stage.gdd_threshold.to_f
    obs.observed_gdd.to_f - predicted
  end

  def predict_date(current_gdd, target_gdd)
    needed = target_gdd - current_gdd
    return Date.current if needed <= 0

    forecasts = WeatherReading
      .where(location: @location)
      .where("date > ?", Date.current)
      .order(:date)

    accumulated = 0.0
    forecasts.each do |r|
      accumulated += daily_gdd(r)
      return r.date if accumulated >= needed
    end

    nil
  end

  def determine_status
    offset = calibration_offset
    if offset > 50
      :delayed
    elsif offset < -50
      :ahead
    else
      :on_track
    end
  end
end
