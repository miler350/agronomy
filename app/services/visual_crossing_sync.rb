class VisualCrossingSync
  BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"

  # Sync a single location for a date range. Defaults to today (picks up forecast days too).
  def self.sync_location(location, from: Date.current, to: Date.current + 15)
    new(location).sync(from:, to:)
  end

  # Sync all locations for the same date range.
  def self.sync_all(from: Date.current, to: Date.current + 15)
    Location.find_each { |loc| sync_location(loc, from:, to:) }
  end

  def initialize(location)
    @location = location
    @api_key  = ENV.fetch("VISUAL_CROSSING_API_KEY")
  end

  def sync(from:, to:)
    data = fetch(from, to)
    return unless data

    data["days"].each { |day| upsert_reading(day) }
    Rails.logger.info "[VC] Synced #{@location.name}: #{from} → #{to}"
  end

  private

  # VC expects "City,State" (no space) in the path, with spaces encoded as %20.
  def encoded_location
    CGI.escape(@location.vc_identifier.gsub(", ", ",")).gsub("+", "%20")
  end

  def fetch(from, to)
    uri = URI("#{BASE_URL}/#{encoded_location}/#{from}/#{to}")
    uri.query = URI.encode_www_form(
      unitGroup: "us",
      include:   "days",
      key:       @api_key,
      contentType: "json"
    )

    response = Net::HTTP.get_response(uri)
    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error "[VC] #{@location.name} HTTP #{response.code}: #{response.body.truncate(200)}"
      return nil
    end

    JSON.parse(response.body)
  rescue => e
    Rails.logger.error "[VC] #{@location.name} error: #{e.message}"
    nil
  end

  def upsert_reading(day)
    date = Date.parse(day["datetime"])

    WeatherReading.find_or_initialize_by(location: @location, date:).tap do |wr|
      wr.assign_attributes(
        max_temperature:    day["tempmax"],
        min_temperature:    day["tempmin"],
        temperature:        day["temp"],
        feels_like_max:     day["feelslikemax"],
        feels_like_min:     day["feelslikemin"],
        feels_like:         day["feelslike"],
        dew:                day["dew"],
        humidity:           day["humidity"],
        precip:             day["precip"],
        precip_prob:        day["precipprob"],
        precip_cover:       day["precipcover"],
        precip_type:        day["preciptype"],
        snow:               day["snow"],
        snow_depth:         day["snowdepth"],
        wind_gust:          day["windgust"],
        wind_speed:         day["windspeed"],
        wind_dir:           day["winddir"],
        sea_level_pressure: day["sealevelpressure"],
        cloud_cover:        day["cloudcover"],
        visibility:         day["visibility"],
        solar_radiation:    day["solarradiation"],
        solar_energy:       day["solarenergy"],
        uv_index:           day["uvindex"],
        severe_risk:        day["severerisk"],
        conditions:         day["conditions"],
        description:        day["description"],
        icon:               day["icon"],
        stations:           Array(day["stations"]).join(",")
      )
      wr.save!
    end
  end
end
