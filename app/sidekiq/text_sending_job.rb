require 'twilio-ruby'

class TextSendingJob
  include Sidekiq::Job

  def perform(body)
    client.messages.create(
      to: ENV["marks_phone_number"],
      from: ENV["twilio_phone_number"],
      body: body
    )
  end

  private

  def client
    @client ||= Twilio::REST::Client.new(ENV["twilio_account_sid"], ENV["twilio_auth_token"])
  end
end
