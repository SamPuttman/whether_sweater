class BookSearchWeatherSerializer
  include JSONAPI::Serializer

  set_type :forecast
  set_id { nil }

  attribute :summary do |object|
    current = object["current"] || {}
    current.dig("condition", "text")
  end

  attribute :temperature do |object|
    current = object["current"] || {}
    "#{current['temp_f']} F"
  end
end
