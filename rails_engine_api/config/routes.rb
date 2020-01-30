Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/:id/items', to: 'merchant_items#index'
      get '/merchants/:id/invoices', to: 'merchant_invoices#index'
      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      get '/merchants/revenue', to: 'merchants#revenue'
      get '/merchants/find', to: 'merchants#find'
      resources :merchants, only: [:index, :show]

      resources :items, only: [:index, :show]
      resources :customers, only: [:index, :show]

      resources :invoices, only: [:index, :show]
      get '/invoices/:id/transactions', to: 'invoices/transactions#index'
      get '/invoices/:id/invoice_items', to: 'invoices/invoice_items#index'
      get '/invoices/:id/items', to: 'invoices/items#index'
      get '/invoices/:id/customer', to: 'invoices/customers#show'
      get '/invoices/:id/merchant', to: 'invoices/merchants#show'

      resources :transactions, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
    end
  end
end
