Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      resources :merchants, only: [:index, :show]
      get '/merchants/:id/items', to: 'merchants/items#index'
      get '/merchants/:id/invoices', to: 'merchants/invoices#index'
      get '/merchants/revenue', to: 'merchants#revenue'
      get '/merchants/find', to: 'merchants#find'

      resources :items, only: [:index, :show]
      get '/items/:id/invoice_items', to: 'items/invoice_items#index'
      get '/items/:id/merchant', to: 'items/merchants#show'

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
