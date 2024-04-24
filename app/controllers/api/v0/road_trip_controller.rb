module Api
  module V0
    class RoadTripController < ApplicationController
      def create
        api_key = params[:api_key]

        if api_key.present? && valid_api_key?(api_key)
          origin = params[:origin]
          destination = params[:destination]

          map_quest_service = RoadTripMapQuestService.new(origin, destination)
          directions_data = map_quest_service.directions

          if directions_data[:info][:statuscode] == 0
            travel_time = map_quest_service.travel_time(directions_data)
            arrival_time = map_quest_service.arrival_time

            weather_service = RoadTripWeatherService.new(destination)
            weather_at_eta = arrival_time ? weather_service.weather_at_eta(arrival_time) : {}

            render json: {
              data: {
                id: nil,
                type: 'road_trip',
                attributes: {
                  start_city: origin,
                  end_city: destination,
                  travel_time: travel_time,
                  weather_at_eta: weather_at_eta
                }
              }
            }, status: :ok
          else
            render json: { error: 'Impossible route' }, status: :bad_request
          end
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      private

      def valid_api_key?(api_key)
        User.exists?(api_key: api_key)
      end
    end
  end
end
