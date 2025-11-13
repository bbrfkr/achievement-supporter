module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      def index
        render json: {
          message: "hello!"
        }
      end
    end
  end
end