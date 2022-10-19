require 'active_support/core_ext/time'

class TextWebhookService
  class NoMessageError < StandardError
  end

  class NoDateError < StandardError
  end

  DATE_REGEX = /(\d{1,2}\/\d{1,2}\/\d{4})/

  def initialize(params)
    @params = params
  end

  def call
    user = User.find_by_phone_number(phone_number)
    return TextSignUpJob.perform_async(phone_number) unless user

    reminder = user.reminders.new
    message = parse_message
    reminder.text = message[:message]
    reminder.run_at = message[:date]
    if reminder.save
      TextSendingJob.perform_at(
        reminder.run_at.in_time_zone("America/Denver"),
        reminder.id
      )
    end
    TextSendingJob.perform_async(reminder.id, confirmation: true)
  rescue StandardError => e
    TextNotScheduledJob.perform_async(user.id, e.class)
  end

  def self.call(params)
    new(params).call
  end

  private

  attr_reader :params

  def phone_number
    params["From"].sub(/^\+1/, '') if params["From"]
  end

  def parse_message
    @message ||= {
      date: retrieve_date,
      message: retrieve_message
    }
  end

  def retrieve_date
    date_string = params["Body"].match(DATE_REGEX)
    if date_string.nil?
      raise NoDateError
    else
      date_and_time = "#{date_string[0]} 08:00 AM"

      Time.strptime(date_and_time, "%m/%d/%Y %I:%M %p")
    end
  end

  def retrieve_message
    text = params["Body"].sub!(DATE_REGEX, '')
    raise NoMessageError if text.blank?

    text
  end
end
