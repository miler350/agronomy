class DashboardController < ApplicationController
  layout "dashboard"

  def index
    @rows = PlantingEvent.includes(field: :location, field_observations: :growth_stage)
      .joins(:field)
      .order("fields.name")
      .map do |pe|
        result = GddCalculator.calculate(pe)
        { planting_event: pe, result: }
      end

    @last_synced = WeatherReading.maximum(:updated_at)
  end
end
