require 'rails_helper'

RSpec.describe RoadTrip do
  it 'has correct attributes' do
    road_trip = RoadTrip.new('St Louis, MO', 'Denver, CO', '40:00:00', {
      datetime: '2023-06-08 12:00', temperature: 75.2, condition: 'Sunny'
    })

    expect(road_trip.start_city).to eq('St Louis, MO')
    expect(road_trip.end_city).to eq('Denver, CO')
    expect(road_trip.travel_time).to eq('40:00:00')
    expect(road_trip.weather_at_eta).to eq({
      datetime: '2023-06-08 12:00', temperature: 75.2, condition: 'Sunny'
    })
  end
end
