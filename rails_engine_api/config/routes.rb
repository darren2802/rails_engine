Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/find#show'
      get '/merchants/find_all', to: 'merchants/find#index'
      get '/merchants/random', to: 'merchants/find#random'
      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      get '/merchants/revenue', to: 'merchants#revenue'
      resources :merchants, only: [:index, :show]
      get '/merchants/:id/items', to: 'merchants/items#index'
      get '/merchants/:id/invoices', to: 'merchants/invoices#index'
      get '/merchants/:id/favorite_customer', to: 'merchants#favorite_customer'
      get '/merchants/:id/customers_with_pending_invoices', to: 'merchants#pending_invoices'

      get '/items/find', to: 'items/find#show'
      get '/items/find_all', to: 'items/find#index'
      get '/items/most_revenue', to: 'items#most_revenue'
      resources :items, only: [:index, :show]
      get '/items/:id/invoice_items', to: 'items/invoice_items#index'
      get '/items/:id/merchant', to: 'items/merchants#show'
      get '/items/:id/best_day', to: 'items#best_day'

      get '/customers/find', to: 'customers/find#show'
      get '/customers/find_all', to: 'customers/find#index'
      get '/customers/:id/favorite_merchant', to: 'merchants#favorite_merchant'
      resources :customers, only: [:index, :show]
      get '/customers/:id/invoices', to: 'customers/invoices#index'
      get '/customers/:id/transactions', to: 'customers/transactions#index'

      resources :invoices, only: [:index, :show]
      get '/invoices/:id/transactions', to: 'invoices/transactions#index'
      get '/invoices/:id/invoice_items', to: 'invoices/invoice_items#index'
      get '/invoices/:id/items', to: 'invoices/items#index'
      get '/invoices/:id/customer', to: 'invoices/customers#show'
      get '/invoices/:id/merchant', to: 'invoices/merchants#show'

      resources :transactions, only: [:index, :show]
      get '/transactions/:id/invoice', to: 'transactions/invoices#show'

      resources :invoice_items, only: [:index, :show]
      get '/invoice_items/:id/invoice', to: 'invoice_items/invoices#show'
      get '/invoice_items/:id/item', to: 'invoice_items/items#show'
    end
  end
end
