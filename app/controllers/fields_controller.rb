class FieldsController < ApplicationController
  layout "dashboard"
  before_action :set_field, only: [:show, :edit, :update, :destroy]

  def index
    @fields = Field.includes(:location, :planting_events).order(:name)
  end

  def show
    @current_planting_event = @field.planting_events.order(planted_on: :desc).first
    @gdd_result = GddCalculator.calculate(@current_planting_event) if @current_planting_event
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

  private

  def set_field
    @field = Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :location_id, :latitude, :longitude)
  end
end
