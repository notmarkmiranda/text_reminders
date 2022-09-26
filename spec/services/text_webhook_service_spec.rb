require "rails_helper"

RSpec.describe TextWebhookService do
  subject { described_class.call(params) }

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

  describe "when the user does not exist" do
    it "calls the TextSignUpJob" do
      expect(TextSignUpJob).to receive(:perform_async).with("3038476953").once

      subject
    end
  end
  describe "when the user exists" do
    before { create(:user, phone_number: "3038476953") }

    describe "when a message is validly formatted" do
      it "creates a reminder" do
        expect { subject }.to change(Reminder, :count).by(1)
      end

      it "calls the TextSendingJob" do
        expected_time = Time.use_zone("America/Denver") do
          Time.zone.local(2022, 9, 13, 8, 00, 00)
        end
        expect(TextSendingJob).to receive(:perform_at).with(expected_time, Integer).once

        subject
      end
    end

    describe "when the message is missing a date" do
      before { params.merge!("Body" => "Take out the trash") }

      it "calls the TextNotScheduledJob" do
        expect(TextNotScheduledJob).to receive(:perform_async).once
        subject
      end
    end

    describe "when the message is missing text" do
      before { params.merge!("Body" => "09/13/2022") }

      it "calls the TextNotScheduledJob" do
        expect(TextNotScheduledJob).to receive(:perform_async).once

        subject
      end
    end
  end
end
