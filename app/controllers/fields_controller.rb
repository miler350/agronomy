class FieldsController < ApplicationController
  layout "dashboard"
  before_action :set_field, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @fields = Field.includes(:location, :planting_events).order(:name)
  end

  def show
    @current_planting_event = @field.planting_events.order(planted_on: :desc).first
    @gdd_result = GddCalculator.calculate(@current_planting_event) if @current_planting_event
    @growth_stages = GrowthStage.where.not(gdd_threshold: nil).order(:position)
    @observations = @current_planting_event&.field_observations
      &.includes(:growth_stage)
      &.order(observed_on: :desc) || []

    if @current_planting_event
      cumulative = 0.0
      readings = WeatherReading
        .where(location: @field.location)
        .where("date >= ?", @current_planting_event.planted_on)
        .where("date <= ?", Date.current)
        .order(:date)
      @gdd_chart_data = readings.map do |r|
        tmax = [r.max_temperature.to_f, 86].min
        tmin = [r.min_temperature.to_f, 50].max
        cumulative += [(tmax + tmin) / 2.0 - 50, 0].max
        { date: r.date.strftime("%b %-d"), gdd: cumulative.round(1) }
      end
    else
      @gdd_chart_data = []
    end
  end

  def new
    @field = Field.new
  end

  def edit
  end

  def create
    @field = Field.new(field_params)
    if @field.save
      redirect_to fields_path, notice: "Field was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @field.update(field_params)
      redirect_to fields_path, notice: "Field was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @field.destroy
    redirect_to fields_path, notice: "Field was successfully deleted."
  end

  def geojson_collection
    static_path = Rails.root.join("public", "fields.geojson")
    base = File.exist?(static_path) ? JSON.parse(File.read(static_path)) : { "type" => "FeatureCollection", "features" => [] }

    db_geometries = Field.where.not(geojson_polygon: [nil, ""]).each_with_object({}) do |f, h|
      h[f.name] = JSON.parse(f.geojson_polygon) rescue nil
    end

    base["features"].each do |feature|
      fid = feature.dig("properties", "field_id")
      feature["geometry"] = db_geometries[fid] if db_geometries[fid]
    end

    render json: base
  end

  private

  def set_field
    @field = Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :location_id, :latitude, :longitude, :farm, :geojson_polygon)
  end
end
