class RoadTripFacade
  def initialize(origin, destination, api_key)
    @origin = origin
    @destination = destination
    @api_key = api_key
  end

  def road_trip_details
    return { error: 'Unauthorized' } unless valid_api_key?(@api_key)

    map_quest_service = RoadTripMapQuestService.new(@origin, @destination)
    directions_data = map_quest_service.directions

    if directions_data[:info][:statuscode] == 0
      travel_time = map_quest_service.travel_time(directions_data)
      arrival_time = map_quest_service.arrival_time

      weather_service = RoadTripWeatherService.new(@destination)
      weather_at_eta = arrival_time ? weather_service.weather_at_eta(arrival_time) : {}

      {
        data: {
          id: nil,
          type: 'road_trip',
          attributes: {
            start_city: @origin,
            end_city: @destination,
            travel_time: travel_time,
            weather_at_eta: weather_at_eta
          }
        }
      }
    else
      { error: 'Impossible route' }
    end
  end

  private

  def valid_api_key?(api_key)
    User.exists?(api_key: api_key)
  end
end
