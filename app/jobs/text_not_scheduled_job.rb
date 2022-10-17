class TextNotScheduledJob < ApplicationJob
  include Sidekiq::Job

  NO_DATE = "TextWebhookService::NoDateError"
  NO_MESSAGE = "TextWebhookService::NoMessageError"

  def perform(user_id, error_class)
    user = User.find_by(id: user_id)
    return unless user

    client.messages.create(
      to: "+1#{user.phone_number}",
      from: ENV["twilio_phone_number"],
      body: body_text(error_class)
    )
  end

  private

  def body_text(error_class)
    case error_class
    when NO_DATE
      "There is no date in the reminder you sent"
    when NO_MESSAGE
      "There is no text in the reminder you sent"
    else
      "Something went wrong"
    end
  end
end
