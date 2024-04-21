class WeatherService
  require 'faraday'

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def forecast
    conn = Faraday.new(url: 'http://api.weatherapi.com')
    response = conn.get('/v1/forecast.json', {
      key: Rails.application.credentials.weatherapi[:api_key],
      q: "#{@latitude},#{@longitude}",
      days: 7
    })
    JSON.parse(response.body)
  end
end
