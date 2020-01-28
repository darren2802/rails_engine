require 'CSV'

namespace :db do
  desc "Clears data that was imported using import_csv"
  task :clear_csv => :environment do
    InvoiceItem.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Item.destroy_all
    Customer.destroy_all
    Merchant.destroy_all
  end

  desc "Reads csv files and uploads them to the relevant db tables"
  task :import_csv => :environment do
    # import customer data
    columns = [:id, :first_name, :last_name, :created_at, :updated_at]
    customer_data = CSV.read('./db/data/customers.csv')
    customer_data.shift
    Customer.import columns, customer_data, validate: true

    # import merchants
    columns = [:id, :name, :created_at, :updated_at]
    merchant_data = CSV.read('./db/data/merchants.csv')
    merchant_data.shift
    Merchant.import columns, merchant_data, validate: true

    # import invoices
    columns = [:id, :customer_id, :merchant_id, :status, :created_at, :updated_at]
    invoice_data = CSV.read('./db/data/invoices.csv')
    invoice_data.shift
    Invoice.import columns, invoice_data, validate: true

    # import items
    columns = [:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at]
    item_data = CSV.read('./db/data/items.csv')
    item_data.shift
    Item.import columns, item_data, validate: true

    # import invoice_items
    columns = [:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at]
    invoice_item_data = CSV.read('./db/data/invoice_items.csv')
    invoice_item_data.shift
    InvoiceItem.import columns, invoice_item_data, validate: true

    # import transactions
    columns = [:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at]
    transaction_data = CSV.read('./db/data/transactions.csv')
    transaction_data.shift
    Transaction.import columns, transaction_data, validate: true
  end
end
