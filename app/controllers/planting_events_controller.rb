class PlantingEventsController < ApplicationController
  layout "dashboard"
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @events = PlantingEvent.includes(field: :location).joins(:field).order("fields.name")
  end

  def show
    @observations = @event.field_observations.includes(:growth_stage).order(observed_on: :desc)
  end

  def new
    @event = PlantingEvent.new
  end

  def edit
  end

  def create
    @event = PlantingEvent.new(event_params)
    if @event.save
      redirect_to planting_events_path, notice: "Planting event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to planting_events_path, notice: "Planting event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to planting_events_path, notice: "Planting event was successfully deleted."
  end

  private

  def set_event
    @event = PlantingEvent.find(params[:id])
  end

  def event_params
    params.require(:planting_event).permit(:field_id, :planted_on, :product)
  end
end
