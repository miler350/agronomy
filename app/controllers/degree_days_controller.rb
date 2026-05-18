class DegreeDaysController < ApplicationController
  layout "dashboard"

  def index
    @rows = PlantingEvent
      .includes(field: :location, field_observations: :growth_stage)
      .joins(:field)
      .order("fields.name")
      .map do |pe|
        { planting_event: pe, result: GddCalculator.calculate(pe) }
      end
  end
end
