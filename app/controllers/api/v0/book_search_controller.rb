module Api
  module V0
    class BookSearchController < ApplicationController
      def index
        location = params[:location]
        quantity = params[:quantity].to_i

        if location.blank? || quantity <= 0
          render json: { error: 'Invalid parameters' }, status: :bad_request
          return
        end

        city, state = parse_location(location)
        lat, lng = MapQuestService.new(city, state).coordinates

        if lat.nil? || lng.nil?
          render json: { error: 'Location not found' }, status: :not_found
          return
        end

        weather_data = WeatherService.new(lat, lng).forecast

        if weather_data.nil?
          render json: { error: 'Weather data not available' }, status: :service_unavailable
          return
        end

        books_data = OpenLibraryService.new(location, quantity).search_books

        render json: {
          data: {
            id: 'null',
            type: 'books',
            attributes: {
              destination: location,
              forecast: BookSearchWeatherSerializer.new(weather_data).serializable_hash[:data][:attributes],
              total_books_found: books_data['numFound'],
              books: parse_books(books_data)
            }
          }
        }
      end

      private

      def parse_location(location)
        location_parts = location.split(',')
        city = location_parts[0].strip
        state = location_parts.length > 1 ? location_parts[1].strip : nil
        [city, state]
      end

      def parse_books(books_data)
        books_data['docs'].map do |book|
          {
            isbn: book['isbn'] || [],
            title: book['title'],
            publisher: book['publisher'] || []
          }
        end
      end
    end
  end
end
