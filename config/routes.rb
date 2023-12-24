Rails.application.routes.draw do
  root to: "chats#index"

  resources :chats, only: %i[ create index show ], param: :token

  mount ActionCable.server => "/cable"
end
