class MapController < ApplicationController
  layout "dashboard"

  def index
    field_data = {}
    PlantingEvent.includes(field: :location, field_observations: :growth_stage)
      .joins(:field)
      .each do |pe|
        result = GddCalculator.calculate(pe)
        field_data[pe.field.name] = {
          gdd: result.calibrated_gdd.round,
          stage: result.current_stage&.name || "—",
          next_stage: result.next_stage&.name || "—",
          status: result.status.to_s,
          product: pe.product,
          planted_on: pe.planted_on.strftime("%b %-d, %Y"),
          location: pe.field.location.name,
          gdd_to_next: result.gdd_to_next.round
        }
      end
    @field_data_json = field_data.to_json
  end
end
