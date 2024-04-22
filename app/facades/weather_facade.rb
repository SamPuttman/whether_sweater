class WeatherFacade
  def self.forecast(location)
    city, state = parse_location(location)
    return { error: 'Both city and state must be provided' } if city.blank? || state.blank?

    lat, lng = MapQuestService.new(city, state).coordinates
    return { error: 'Location not found' } if lat.nil? || lng.nil?

    weather_data = WeatherService.new(lat, lng).forecast
    return { error: 'Weather data not available' } if weather_data.nil?

    WeatherSerializer.new(weather_data).serializable_hash
  end

  private

  def self.parse_location(location)
    location_parts = location.split(',')
    city = location_parts[0].strip
    state = location_parts.length > 1 ? location_parts[1].strip : nil
    [city, state]
  end
end
