require 'twilio-ruby'

class TextSendingJob < ApplicationJob
  include Sidekiq::Job

  def perform(reminder_id)
    reminder = Reminder.includes(:user).find_by(id: reminder_id)
    return if reminders_disabled? || reminder.nil?
    reminder.update(jid: jid)

    client.messages.create(
      to: "+1#{reminder.user_phone_number}",
      from: ENV["twilio_phone_number"],
      body: reminder.text
    )
  end
end
