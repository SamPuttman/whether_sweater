require 'rails_helper'

RSpec.describe 'Road Trip Map Quest Request' do
  describe 'POST /road_trip' do
    let(:user) { create(:user) }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

    context 'with valid parameters' do
      it 'returns a successful response with road trip data' do
        VCR.use_cassette('road_trip_request_success') do
          post '/api/v0/road_trip', params: {
            origin: 'St Louis, MO',
            destination: 'Denver, CO',
            api_key: user.api_key
          }.to_json, headers: headers

          expect(response).to be_successful
          expect(response.status).to eq(200)

          road_trip_data = JSON.parse(response.body, symbolize_names: true)

          expect(road_trip_data[:data][:id]).to be_nil
          expect(road_trip_data[:data][:type]).to eq('road_trip')
          expect(road_trip_data[:data][:attributes][:start_city]).to eq('St Louis, MO')
          expect(road_trip_data[:data][:attributes][:end_city]).to eq('Denver, CO')
          expect(road_trip_data[:data][:attributes][:travel_time]).to be_a(String)
        end
      end
    end

    context 'with invalid API key' do
      it 'returns an unauthorized error' do
        post '/api/v0/road_trip', params: {
          origin: 'St Louis, MO',
          destination: 'Denver, CO',
          api_key: 'bullshit_api_key'
        }.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Unauthorized')
      end
    end

    context 'with bad route' do
      it 'returns a bad request error' do
        VCR.use_cassette('road_trip_request_impossible') do
          post '/api/v0/road_trip', params: {
            origin: 'St Louis, MO',
            destination: 'London, UK',
            api_key: user.api_key
          }.to_json, headers: headers

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include('Impossible route')
        end
      end
    end
  end

  describe 'directions' do
    let(:origin) { 'St Louis, MO' }
    let(:destination) { 'Denver, CO' }
    let(:service) { RoadTripMapQuestService.new(origin, destination) }

    context 'when the API request is successful' do
      it 'returns the parsed JSON response' do
        VCR.use_cassette('mapquest_directions_success') do
          response = service.directions
          expect(response).to be_a(Hash)
        end
      end
    end
  end
end
