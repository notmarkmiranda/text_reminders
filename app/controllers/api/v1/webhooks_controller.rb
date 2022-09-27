module Api
  module V1
    class WebhooksController < ApplicationController
      skip_before_action :verify_authenticity_token

      def twilio_sms
        TextWebhookService.call(params)
        render json: { message: "okay" }
      end
    end
  end
end
