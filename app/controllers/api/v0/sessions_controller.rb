module Api
  module V0
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: session_params[:email])

        if user && user.authenticate(session_params[:password])
          render json: UserSerializer.new(user), status: :ok
        else
          render json: { error: 'Invalid login' }, status: :unauthorized
        end
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
