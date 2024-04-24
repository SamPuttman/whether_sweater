module Api
  module V0
    class RoadTripController < ApplicationController
      def create
        facade = RoadTripFacade.new(params[:origin], params[:destination], params[:api_key])
        result = facade.road_trip_details

        if result[:error]
          render json: { error: result[:error] }, status: result[:error] == 'Unauthorized' ? :unauthorized : :bad_request
        else
          render json: result, status: :ok
        end
      end
    end
  end
end
