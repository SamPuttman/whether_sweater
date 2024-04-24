require 'rails_helper'

RSpec.describe RoadTripSerializer do
  it 'serializes the road trip data' do
    road_trip = RoadTrip.new('St Louis, MO', 'Denver, CO', '40:00:00', {
      datetime: '2023-06-08 12:00',
      temperature: 75.2,
      condition: 'Sunny'
    })
    serializer = RoadTripSerializer.new(road_trip)
    serialized_data = serializer.serializable_hash

    expect(serialized_data[:data][:id]).to be_nil
    expect(serialized_data[:data][:type]).to eq(:road_trip)
    expect(serialized_data[:data][:attributes][:start_city]).to eq('St Louis, MO')
    expect(serialized_data[:data][:attributes][:end_city]).to eq('Denver, CO')
    expect(serialized_data[:data][:attributes][:travel_time]).to eq('40:00:00')
    expect(serialized_data[:data][:attributes][:weather_at_eta]).to eq({
      datetime: '2023-06-08 12:00',
      temperature: 75.2,
      condition: 'Sunny'
    })
  end

  context 'with impossible travel time' do
    it 'serializes the road trip data with empty weather attribute' do
      road_trip = RoadTrip.new('St Louis, MO', 'London, UK', 'impossible', {})
      serializer = RoadTripSerializer.new(road_trip)
      serialized_data = serializer.serializable_hash

      expect(serialized_data[:data][:attributes][:weather_at_eta]).to be_empty
    end
  end
end
