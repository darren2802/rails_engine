Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index]
      get '/merchants/:id/items', to: 'merchant_items#index'
      resources :items, only: [:index]
      resources :customers, only: [:index]
      resources :invoices, only: [:index]
      resources :transactions, only: [:index]
      resources :invoice_items, only: [:index]
    end
  end
end
