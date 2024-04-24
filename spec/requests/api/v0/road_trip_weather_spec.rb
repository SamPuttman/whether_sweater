require 'rails_helper'

RSpec.describe RoadTripWeatherService do
  describe '#weather_at_eta' do
    let(:arrival_time) { Time.now + 2.days }
    let(:service) { RoadTripWeatherService.new('Los Angeles, CA') }

    context 'when the API request is successful' do
      it 'returns the weather data at the estimated time of arrival' do
        VCR.use_cassette('road_trip_weather_at_eta_success') do
          response = service.weather_at_eta(arrival_time)
          expect(response).to be_a(Hash)
          expect(response[:datetime]).to eq(arrival_time.strftime('%Y-%m-%d %H:%M'))
          expect(response[:temperature]).to be_present
          expect(response[:condition]).to be_present
        end
      end
    end
  end
end
