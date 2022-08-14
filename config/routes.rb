require 'sidekiq/web'

Rails.application.routes.draw do
  root to: "reminders#index"

  mount Sidekiq::Web => "/sidekiq"
  resources :reminders, only: [:index, :new, :create]
end
