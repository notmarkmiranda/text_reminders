require "rails_helper"

RSpec.describe Api::V1::WebhooksController, type: :request do
  describe "twilio_sms" do
    let(:params) do
      {
        "ToCountry"=>"US",
        "ToState"=>"MO",
        "SmsMessageSid"=>"SMad1cc00f088802eb10e9f336487056fe",
        "NumMedia"=>"0",
        "ToCity"=>"",
        "FromZip"=>"80238",
        "SmsSid"=>"SMad1cc00f088802eb10e9f336487056fe",
        "FromState"=>"CO",
        "SmsStatus"=>"received",
        "FromCity"=>"DENVER",
        "Body"=> "Take out the trash 09/13/2022",
        "FromCountry"=>"US",
        "To"=>"+13149362802",
        "MessagingServiceSid"=>"MG0e4cebcfb8ebdc5913133a597e2a852b",
        "ToZip"=>"",
        "NumSegments"=>"1",
        "ReferralNumMedia"=>"0",
        "MessageSid"=>"SMad1cc00f088802eb10e9f336487056fe",
        "AccountSid"=>"ACed9475303cf99a1c8f2fd5b31d65d61e",
        "From"=>"+13038476953",
        "ApiVersion"=>"2010-04-01",
        "controller"=>"api/v1/webhooks",
        "action"=>"twilio_sms"
      }
    end

    subject { post "/api/v1/webhooks/twilio_sms", params: params }


    it "replies for the user to sign up in a browser" do
      expect(TextWebhookService).to receive(:call).with(params).once

      subject
    end
  end
end
