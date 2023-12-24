Rails.application.routes.draw do
  root to: "chats#index"

  resources :chats, only: %i[ create index show ], param: :token

  namespace :api do
    resources :chats, only: [:index], param: :token do
      member do
        post 'create_message'
      end
    end
  end

  mount ActionCable.server => "/cable"
end
