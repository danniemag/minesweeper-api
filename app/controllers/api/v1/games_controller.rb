module Api
  module V1
    class GamesController < ApplicationController
      def teste
        render json: { success: true, message: 'Return anything' }
      end
    end
  end
end
