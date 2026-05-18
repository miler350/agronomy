class FieldObservationsController < ApplicationController
  layout "dashboard"

  def create
    @field = Field.find(params[:field_id])
    @planting_event = @field.planting_events.order(planted_on: :desc).first

    unless @planting_event
      redirect_to field_path(@field), alert: "No planting event found for this field."
      return
    end

    @observation = @planting_event.field_observations.build(observation_params)

    if @observation.save
      redirect_to field_path(@field), notice: "Observation logged."
    else
      redirect_to field_path(@field), alert: @observation.errors.full_messages.join(", ")
    end
  end

  def destroy
    @observation = FieldObservation.find(params[:id])
    @field = @observation.planting_event.field
    @observation.destroy
    redirect_to field_path(@field), notice: "Observation deleted."
  end

  private

  def observation_params
    params.require(:field_observation).permit(:observed_on, :growth_stage_id, :observed_gdd, :notes)
  end
end
