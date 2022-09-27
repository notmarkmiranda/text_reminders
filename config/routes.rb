require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  root to: "reminders#index"

  resources :reminders, only: [:index, :new, :create]

  get '/sign-in', to: 'sessions#new', as: 'sign_in'
  post '/sign-in', to: 'sessions#create'
  get '/sign-out', to: 'sessions#destroy', as: 'sign_out'
  get '/confirm/:uuid', to: 'sessions#confirm', as: 'confirm'
  post '/verification', to: 'sessions#verification', as: 'session_verification'

  get  '/edit-profile', to: 'users#edit', as: 'edit_profile'
  patch '/users', to: 'users#update', as: 'update_user'

  namespace :api do
    namespace :v1 do
      post "/webhooks/twilio_sms"
    end
  end
end
