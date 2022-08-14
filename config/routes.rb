Rails.application.routes.draw do
  root to: "reminders#index"

  resources :reminders, only: [:index, :new, :create]
end
