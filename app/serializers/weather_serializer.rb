class WeatherSerializer
  include JSONAPI::Serializer
  set_type :forecast
  set_id { nil }

  attribute :current_weather do |object|
    current = object["current"] || {}
    {
      last_updated: current["last_updated"],
      temperature: current["temp_f"],
      feels_like: current["feelslike_f"],
      humidity: current["humidity"],
      uvi: current["uv"],
      visibility: current["vis_miles"],
      condition: current.dig("condition", "text"),
      icon: format_icon_url(current.dig("condition", "icon"))
    }
  end

  attribute :daily_weather do |object|
    (object.dig("forecast", "forecastday") || []).map do |day|
      day_data = day["day"] || {}
      condition = day_data["condition"] || {}
      {
        date: day["date"],
        sunrise: day.dig("astro", "sunrise"),
        sunset: day.dig("astro", "sunset"),
        max_temp: day_data["maxtemp_f"],
        min_temp: day_data["mintemp_f"],
        condition: condition["text"],
        icon: format_icon_url(condition["icon"])
      }
    end
  end

  attribute :hourly_weather do |object|
    (object.dig("forecast", "forecastday", 0, "hour") || []).map do |hour|
      {
        time: hour["time"],
        temperature: hour["temp_f"],
        conditions: hour.dig("condition", "text"),
        icon: format_icon_url(hour.dig("condition", "icon"))
      }
    end
  end

  attribute :summary do |object|
    current = object["current"] || {}
    current.dig("condition", "text")
  end

  attribute :temperature do |object|
    current = object["current"] || {}
    "#{current['temp_f']} F"
  end

  def self.format_icon_url(url)
    url ? "https:#{url}" : nil
  end
end
