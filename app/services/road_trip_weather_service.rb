class RoadTripWeatherService
  def initialize(destination)
    @destination = destination
  end

  def weather_at_eta(arrival_time)
    conn = Faraday.new(url: 'http://api.weatherapi.com')
    response = conn.get('/v1/forecast.json', {
      key: Rails.application.credentials.weatherapi[:api_key],
      q: @destination,
      dt: arrival_time.iso8601
    })

    if response.success?
      data = JSON.parse(response.body)
      {
        datetime: arrival_time.strftime('%Y-%m-%d %H:%M'),
        temperature: data['forecast']['forecastday'][0]['hour'][0]['temp_f'],
        condition: data['forecast']['forecastday'][0]['hour'][0]['condition']['text']
      }
    else
      {}
    end
  rescue JSON::ParserError
    {}
  end
end
