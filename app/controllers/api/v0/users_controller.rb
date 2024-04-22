module Api
  module V0
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)

        if user.save
          render json: UserSerializer.new(user), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
