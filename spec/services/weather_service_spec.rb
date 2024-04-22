require 'rspec'

RSpec.describe WeatherService, :vcr do

  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }
  let(:weather_service) { WeatherService.new(latitude, longitude) }

  context 'when the API returns a successful response' do
    it 'returns a parsed JSON object' do
      result = weather_service.forecast
      expect(result).to be_a(Hash)
      expect(result['location']['name']).to eq('New York')
    end
  end
end
