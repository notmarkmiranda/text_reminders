class BaseJob
  def client
    @client ||= Twilio::REST::Client.new(ENV["twilio_account_sid"], ENV["twilio_auth_token"])
  end

  def reminders_disabled?
    ENV["disable_reminders"] == "true"
  end
end
