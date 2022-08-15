require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  root to: "reminders#index"

  resources :reminders, only: [:index, :new, :create]
  get '/sign-in', to: 'sessions#new', as: 'sign_in'
  post '/sign-in', to: 'sessions#create'
  get '/confirm/:uuid', to: 'sessions#confirm', as: 'confirm'
  post '/verification', to: 'sessions#verification', as: 'session_verification'
end
