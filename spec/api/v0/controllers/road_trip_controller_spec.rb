require 'rails_helper'

RSpec.describe Api::V0::RoadTripController, type: :request do
  describe 'POST /road_trip' do
    let(:user) { create(:user) }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

    context 'with valid parameters' do
      it 'returns a successful response with road trip data' do
        allow_any_instance_of(RoadTripFacade).to receive(:road_trip_details).and_return({
          data: {
            id: nil,
            type: 'road_trip',
            attributes: {
              start_city: 'St Louis, MO',
              end_city: 'Denver, CO',
              travel_time: '15:30',
              weather_at_eta: {}
            }
          }
        })

        post '/api/v0/road_trip', params: {
          origin: 'St Louis, MO',
          destination: 'Denver, CO',
          api_key: user.api_key
        }.to_json, headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid API key' do
      it 'returns an unauthorized error' do
        post '/api/v0/road_trip', params: {
          origin: 'St Louis, MO',
          destination: 'Denver, CO',
          api_key: 'invalid_api_key'
        }.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
