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

        result = BookSearchFacade.search(location, quantity)

        if result[:error]
          handle_errors(result[:error])
        else
          render json: {
            data: {
              id: 'null',
              type: 'books',
              attributes: result
            }
          }
        end
      end

      private

      def handle_errors(error)
        case error
        when 'Both city and state must be provided', 'Invalid parameters'
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
