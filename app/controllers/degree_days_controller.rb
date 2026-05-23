class DegreeDaysController < ApplicationController
  layout "dashboard"

  def index
    @growth_stages = GrowthStage.where.not(gdd_threshold: nil).order(:position)
    @rows = PlantingEvent
      .includes(field: :location, field_observations: :growth_stage)
      .joins(:field)
      .order("fields.name")
      .map do |pe|
        { planting_event: pe, result: GddCalculator.calculate(pe) }
      end
  end
end
