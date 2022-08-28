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

  subject { TextSendingJob.perform_async(reminder.id) }

  it 'calls messages.create with the correct arguments' do
    Sidekiq::Testing.inline! do
      stub_const('ENV', ENV.to_hash.merge('disable_reminders' => 'false'))
      allow(Twilio::REST::Client).to receive(:new).with("asdf", "superduper").and_return(twilio_double)
      expect(twilio_double).to receive(:messages).and_return(messages)
      expect(messages).to receive(:create).with(arguments)

      subject
    end
  end

  it 'updates the reminder with a jid' do
    Sidekiq::Testing.inline! do
      stub_const('ENV', ENV.to_hash.merge('disable_reminders' => 'false'))
      allow(Twilio::REST::Client).to receive(:new).with("asdf", "superduper").and_return(twilio_double)
      expect(twilio_double).to receive(:messages).and_return(messages)
      expect(messages).to receive(:create).with(arguments)

      subject

      expect(reminder.reload.jid).not_to be nil
    end
  end
end
