require 'rails_helper'

RSpec.describe Api::V0::WeatherController, type: :controller do
  describe "forecast" do
    let(:map_quest_service) { instance_double(MapQuestService) }
    let(:weather_service) { instance_double(WeatherService) }

    before do
      allow(MapQuestService).to receive(:new).and_return(map_quest_service)
      allow(WeatherService).to receive(:new).and_return(weather_service)
    end

    context 'when location parameter is missing' do
      it 'returns bad request' do
        get :forecast, params: {}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("Location parameter is missing")
      end
    end

    context 'when city or state is missing' do
      it 'returns bad request' do
        get :forecast, params: { location: "Denver," }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("Both city and state must be provided")
      end
    end

    context 'when location is not found' do
      it 'returns not found' do
        allow(map_quest_service).to receive(:coordinates).and_return([nil, nil])
        get :forecast, params: { location: "Nowhere, ZZ" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Location not found")
      end
    end

    context 'when weather data is unavailable' do
      it 'returns service unavailable' do
        allow(map_quest_service).to receive(:coordinates).and_return([39.7392, -104.9903])
        allow(weather_service).to receive(:forecast).and_return(nil)
        get :forecast, params: { location: "Denver, CO" }
        expect(response).to have_http_status(:service_unavailable)
        expect(JSON.parse(response.body)["error"]).to eq("Weather data not available")
      end
    end

    context 'when everything is okay' do
      it 'returns weather data successfully' do
        allow(map_quest_service).to receive(:coordinates).and_return([39.7392, -104.9903])
        allow(weather_service).to receive(:forecast).and_return({
          "current" => {
            "last_updated" => "2023-04-07 16:30",
            "temp_f" => 55.0,
            "feelslike_f" => 55.0,
            "humidity" => 10,
            "uv" => 5.0,
            "vis_miles" => 10,
            "condition" => {
              "text" => "Clear",
              "icon" => "//cdn.weatherapi.com/weather/64x64/day/113.png"
            }
          }
        })

        get :forecast, params: { location: "Denver, CO" }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:success)

        expect(json_response["data"]["attributes"]).to include("current_weather")
        expect(json_response["data"]["attributes"]["current_weather"]).to include(
          "last_updated" => "2023-04-07 16:30",
          "temperature" => 55.0,
          "condition" => "Clear"
        )
      end
    end
  end
end
