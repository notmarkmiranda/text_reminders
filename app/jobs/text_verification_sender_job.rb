class TextVerificationSenderJob < ApplicationJob
  include Sidekiq::Job

  def perform(uuid)
    user = User.find_by_id(uuid)
    return unless user || !reminders_disabled?

    client.messages.create(
      to: "+1#{user.phone_number}",
      from: ENV["twilio_phone_number"],
      body: body(user)
    )
  end

  private

  def body(user)
    "Your verification code is #{user.verification}. This code will expire in about 15 minutes"
  end
end
