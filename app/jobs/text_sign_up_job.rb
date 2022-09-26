class TextSignUpJob < ApplicationJob
  include Sidekiq::Job

  def perform(phone_number)
    client.messages.create(
      to: "+1#{phone_number}",
      from: ENV["twilio_phone_number"],
      body: message
    )
  end

  private

  def message
    "Please sign up on our website: textreminder.app. We need to verify your \
    phone number and time zones before we can start reminding you about things."
  end
end
