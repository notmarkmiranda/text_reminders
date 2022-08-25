source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

gem "rails", "~> 7.0.2", ">= 7.0.2.4"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "delayed_job_active_record"
gem "sidekiq"
gem "twilio-ruby"
gem 'skeleton-rails', :git => 'https://github.com/helios-technologies/skeleton-rails'
gem "dotenv-rails"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "pry"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "figaro"
  gem 'shoulda-matchers', '~> 5.0'
  gem "capybara"
end

group :development do
  gem "web-console"
end

