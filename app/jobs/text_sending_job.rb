require 'twilio-ruby'

class TextSendingJob < ApplicationJob
  include Sidekiq::Job

  def perform(reminder_id, confirmation: false)
    reminder = Reminder.includes(:user).find_by(id: reminder_id)
    return if reminders_disabled? || reminder.nil?
    body = confirmation ? confirmation_text : reminder.text

    client.messages.create(
      to: "+1#{reminder.user_phone_number}",
      from: ENV["twilio_phone_number"],
      body: body
    )
  end

  def confirmation_text
    "Reminder Scheduled!"
  end
end
