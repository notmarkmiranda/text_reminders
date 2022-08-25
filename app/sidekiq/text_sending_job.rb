require 'twilio-ruby'

class TextSendingJob < BaseJob
  include Sidekiq::Job

  def perform(body)
    return if reminders_disabled?

    client.messages.create(
      to: ENV["marks_phone_number"],
      from: ENV["twilio_phone_number"],
      body: body
    )
  end
end
