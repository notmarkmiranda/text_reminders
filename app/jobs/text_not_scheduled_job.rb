class TextNotScheduledJob < ApplicationJob
  include Sidekiq::Job

end
