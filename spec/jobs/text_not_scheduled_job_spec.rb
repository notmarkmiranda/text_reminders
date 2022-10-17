require "rails_helper"

RSpec.describe TextNotScheduledJob, type: :job do
  let(:user) { create(:user) }
  let(:twilio_double) { double('twilio') }
  let(:messages) { double('client_messages') }
  let(:arguments) do
    {
      to: "+1#{user.phone_number}",
      from: ENV["twilio_phone_number"],
      body: body
    }
  end

  describe "NoDateError" do
    let(:body) { "There is no date in the reminder you sent" }

    it 'creates a new job' do
      expect {
        described_class.perform_async(user.id, TextWebhookService::NoDateError)
      }.to change(described_class.jobs, :size).by(1)
    end

    it 'calls messages.create with the correct arguments' do
      Sidekiq::Testing.inline! do
        allow(Twilio::REST::Client).to receive(:new).with("asdf", "superduper").and_return(twilio_double)
        expect(twilio_double).to receive(:messages).and_return(messages)
        expect(messages).to receive(:create).with(arguments)

        described_class.perform_async(user.id, TextWebhookService::NoDateError)
      end
    end
  end

  describe "NoMessageError" do
    let(:body) { "There is no text in the reminder you sent" }

    it "creates a new job" do
      expect {
        described_class.perform_async(user.id, TextWebhookService::NoMessageError)
      }.to change(described_class.jobs, :size).by(1)
    end

    it "calls messages.create with the correct arguments" do
      Sidekiq::Testing.inline! do
        allow(Twilio::REST::Client).to receive(:new).with("asdf", "superduper").and_return(twilio_double)
        expect(twilio_double).to receive(:messages).and_return(messages)
        expect(messages).to receive(:create).with(arguments)

        described_class.perform_async(user.id, TextWebhookService::NoMessageError)
      end
    end
  end
end
