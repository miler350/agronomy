class ScoutingController < ApplicationController
  layout "dashboard"

  def index
    @observations = FieldObservation
      .includes(planting_event: { field: :location }, growth_stage: {})
      .order(observed_on: :desc)
  end
end
