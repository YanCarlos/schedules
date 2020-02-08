Rails.application.routes.draw do

  resources :events, only: :create, constraints: { format: :json }

  root to: 'events#new'
end
