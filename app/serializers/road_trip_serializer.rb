class RoadTripSerializer
  include JSONAPI::Serializer

  set_type :road_trip
  set_id { nil }

  attributes :start_city, :end_city, :travel_time

  attribute :weather_at_eta do |trip|
    if trip.travel_time == 'impossible'
      {}
    else
      {
        datetime: trip.weather_at_eta[:datetime],
        temperature: trip.weather_at_eta[:temperature],
        condition: trip.weather_at_eta[:condition]
      }
    end
  end
end
