require 'rspec'

RSpec.describe WeatherSerializer do
  let(:test_data) {
    {
      "current" => {
        "last_updated" => "2024-04-21 12:00",
        "temp_f" => 68.0,
        "feelslike_f" => 70.0,
        "humidity" => 30,
        "uv" => 5.1,
        "vis_miles" => 10,
        "condition" => {"text" => "Sunny", "icon" => "//cdn.weatherapi.com/weather/64x64/day/113.png"}
      },
      "forecast" => {
        "forecastday" => [
          {
            "date" => "2024-04-21 12:00",
            "day" => {
              "maxtemp_f" => 75.0,
              "mintemp_f" => 55.0,
              "condition" => {"text" => "Partly cloudy", "icon" => "//cdn.weatherapi.com/weather/64x64/night/116.png"}
            },
            "astro" => {
              "sunrise" => "6:00 AM",
              "sunset" => "8:00 PM"
            },
            "hour" => [
              {"time" => "12:00", "temp_f" => 68.0, "condition" => {"text" => "Clear", "icon" => "//cdn.weatherapi.com/weather/64x64/day/113.png"}}
            ]
          }
        ]
      }
    }
  }

  describe 'serializing daily_weather' do
    it 'correctly serializes weather data for a single day' do
      serializer = WeatherSerializer.new(test_data)
      result = serializer.serializable_hash[:data][:attributes][:daily_weather].first

      expect(result[:date]).to eq("2024-04-21 12:00")
      expect(result[:sunrise]).to eq("6:00 AM")
      expect(result[:sunset]).to eq("8:00 PM")
      expect(result[:max_temp]).to eq(75.0)
      expect(result[:min_temp]).to eq(55.0)
      expect(result[:condition]).to eq("Partly cloudy")
      expect(result[:icon]).to eq("https://cdn.weatherapi.com/weather/64x64/night/116.png")
    end
  end

  describe 'serializing hourly_weather' do
    it 'correctly serializes weather data for the noon hour' do
      serializer = WeatherSerializer.new(test_data)
      result = serializer.serializable_hash[:data][:attributes][:hourly_weather].first

      expect(result[:time]).to eq("12:00")
      expect(result[:temperature]).to eq(68.0)
      expect(result[:conditions]).to eq("Clear")
      expect(result[:icon]).to eq("https://cdn.weatherapi.com/weather/64x64/day/113.png")
    end
  end
end
