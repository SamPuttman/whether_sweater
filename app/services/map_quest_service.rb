class MapQuestService
  def initialize(city, state)
    @city = city
    @state = state
  end

  def coordinates
    conn = Faraday.new(url: 'http://www.mapquestapi.com')
    response = conn.get('/geocoding/v1/address', {
      key: Rails.application.credentials.mapquest[:api_key],
      location: "#{@city}, #{@state}"
    })

    if response.success?
      body = JSON.parse(response.body)

      if body['info']['statuscode'] == 0 && body['results'][0]['locations'].any?
        location = body['results'][0]['locations'][0]

        if location['geocodeQuality'] == 'CITY'
          lat_lng = location['latLng']
          [lat_lng['lat'], lat_lng['lng']]
        end
      end
    end
  rescue JSON::ParserError
    nil
  end
end
