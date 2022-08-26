require 'rails_helper'

RSpec.describe TextSendingJob, type: :job do
  let(:user) { create(:user, phone_number: "6952331234") }
  let(:reminder) { create(:reminder, user: user) }
  let(:twilio_double) { double('twilio') }
  let(:messages) { double('client_messages') }
  let(:arguments) do
    {
      to: "+1#{user.phone_number}",
      from: ENV["twilio_phone_number"],
      body: reminder.text
    }
  end

  it 'calls messages.create with the correct arguments' do
    Sidekiq::Testing.inline! do
      stub_const('ENV', ENV.to_hash.merge('disable_reminders' => 'false'))
      allow(Twilio::REST::Client).to receive(:new).with("asdf", "superduper").and_return(twilio_double)
      expect(twilio_double).to receive(:messages).and_return(messages)
      expect(messages).to receive(:create).with(arguments)

      TextSendingJob.perform_async(reminder.id)
    end
  end
end
