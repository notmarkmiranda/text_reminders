class TextNotScheduledJob < ApplicationJob
  include Sidekiq::Job

  def perform(user_id, error_class)
    #there is a test that checks to see if this works that is failing
  end
end
