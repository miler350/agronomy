class FieldObservationsController < ApplicationController
  layout "dashboard"
  before_action :require_admin!
  before_action :set_field

  def create
    @planting_event = @field.planting_events.order(planted_on: :desc).first

    unless @planting_event
      redirect_to field_path(@field), alert: "No planting event found for this field."
      return
    end

    observed_on = begin
      Date.parse(params.dig(:field_observation, :observed_on).to_s)
    rescue ArgumentError
      nil
    end

    unless observed_on
      redirect_to field_path(@field), alert: "Invalid observation date."
      return
    end

    observed_gdd = calculate_gdd_for_period(@field.location, @planting_event.planted_on, observed_on)

    tag_ids = Array(params.dig(:field_observation, :tag_ids)).reject(&:blank?).map(&:to_i)

    @observation = @planting_event.field_observations.build(
      params.require(:field_observation).permit(:observed_on, :growth_stage_id, :notes)
    )
    @observation.observed_gdd = observed_gdd

    if @observation.save
      @observation.tags = Tag.where(id: tag_ids)
      redirect_to field_path(@field), notice: "Observation logged (#{observed_gdd.round} GDD accumulated)."
    else
      redirect_to field_path(@field), alert: @observation.errors.full_messages.join(", ")
    end
  end

  def update
    @observation = FieldObservation.find(params[:id])
    @planting_event = @observation.planting_event

    observed_on = begin
      Date.parse(params.dig(:field_observation, :observed_on).to_s)
    rescue ArgumentError
      nil
    end

    unless observed_on
      redirect_to field_path(@field), alert: "Invalid observation date."
      return
    end

    observed_gdd = calculate_gdd_for_period(@field.location, @planting_event.planted_on, observed_on)

    tag_ids = Array(params.dig(:field_observation, :tag_ids)).reject(&:blank?).map(&:to_i)

    permitted = params.require(:field_observation).permit(:observed_on, :growth_stage_id, :notes)
    permitted[:observed_gdd] = observed_gdd

    if @observation.update(permitted)
      @observation.tags = Tag.where(id: tag_ids)
      redirect_to field_path(@field), notice: "Observation updated."
    else
      redirect_to field_path(@field), alert: @observation.errors.full_messages.join(", ")
    end
  end

  def destroy
    @observation = FieldObservation.find(params[:id])
    @observation.destroy
    redirect_to field_path(@field), notice: "Observation deleted."
  end

  private

  def set_field
    @field = Field.find(params[:field_id])
  end

  def calculate_gdd_for_period(location, start_date, end_date)
    readings = WeatherReading
      .where(location: location)
      .where(date: start_date..end_date)
      .order(:date)
    readings.sum { |r| daily_gdd(r) }.round(1)
  end

  def daily_gdd(r)
    return 0 unless r.max_temperature && r.min_temperature
    tmax = [r.max_temperature.to_f, 86].min
    tmin = [r.min_temperature.to_f, 50].max
    [(tmax + tmin) / 2.0 - 50, 0].max
  end
end
