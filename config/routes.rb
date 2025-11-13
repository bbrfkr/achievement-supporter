Rails.application.routes.draw do
  root "health#show"
  get "health", to: "health#show"

  namespace :api, {format: 'json'} do
    namespace :v1 do
      get "users", to: "users#index"
    end
  end
end
