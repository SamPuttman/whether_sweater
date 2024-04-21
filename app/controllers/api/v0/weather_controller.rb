module Api
  module V0
    class WeatherController < ApplicationController
      def forecast
        location = params[:location]
        if location.blank?
          render json: { error: 'Location param is missing' }, status: :bad_request
          return
        end

        result = WeatherFacade.forecast(location)

        if result[:error]
          handle_errors(result[:error])
        else
          render json: result
        end
      end

      private

      def handle_errors(error)
        case error
        when 'Both city and state must be provided'
          render json: { error: error }, status: :bad_request
        when 'Location not found'
          render json: { error: error }, status: :not_found
        when 'Weather data not available'
          render json: { error: error }, status: :service_unavailable
        else
          render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
        end
      end
    end
  end
end
