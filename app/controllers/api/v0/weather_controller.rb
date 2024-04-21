module Api
  module V0
    class WeatherController < ApplicationController
      def forecast
        if params[:location].blank?
          render json: { error: 'Location parameter is missing' }, status: :bad_request
          return
        end

        location = params[:location].split(',')
        city = location[0].strip
        state = location.length > 1 ? location[1].strip : nil

        if city.blank? || state.blank?
          render json: { error: 'Both city and state must be provided' }, status: :bad_request
          return
        end

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

        render json: WeatherSerializer.new(weather_data).serializable_hash
      end
    end
  end
end
