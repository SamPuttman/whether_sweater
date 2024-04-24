require 'rails_helper'

RSpec.describe RoadTripFacade, :vcr do
  describe 'road_trip_details' do
    let(:user) { create(:user) }
    let(:origin) { 'St Louis, MO' }
    let(:destination) { 'Denver, CO' }
    let(:facade) { RoadTripFacade.new(origin, destination, user.api_key) }

    context 'when the API request is successful' do
      it 'returns road trip data' do
        result = facade.road_trip_details
        expect(result).to include(:data)
        expect(result[:data][:attributes][:start_city]).to eq(origin)
        expect(result[:data][:attributes][:end_city]).to eq(destination)
      end
    end

    context 'with invalid API key' do
      let(:facade) { RoadTripFacade.new(origin, destination, 'invalid_api_key') }

      it 'returns an unauthorized error' do
        result = facade.road_trip_details
        expect(result).to include(:error)
        expect(result[:error]).to eq('Unauthorized')
      end
    end
  end
end
