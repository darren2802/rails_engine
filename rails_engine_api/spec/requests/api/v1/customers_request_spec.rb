require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    create_list(:customer, 5)

    get '/api/v1/customers'
    expect(response).to be_successful
    customers = JSON.parse(response.body)
    expect(customers['data'].count).to eq(5)
  end

  it 'sends a particular customer' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)

    get "/api/v1/customers/#{customer_2.id}"
    expect(response).to be_successful
    customer = JSON.parse(response.body)
    expect(customer['data']['attributes']['first_name']).to eq(customer_2.first_name)
    expect(customer['data']['attributes']['last_name']).to eq(customer_2.last_name)
  end

  it 'can send a collection of associated invoices for a customer' do
    customer = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    invoice_1 = create(:invoice, customer_id: customer.id, merchant_id: merchant_1.id)
    invoice_2 = create(:invoice, customer_id: customer.id, merchant_id: merchant_2.id)

    get "/api/v1/customers/#{customer.id}/invoices"
    expect(response).to be_successful
    invoices_json = JSON.parse(response.body)
    expect(invoices_json['data'].count).to eq(2)
  end

  it 'send a collection of associated transactions for a customer' do
    customer = create(:customer)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    invoice_1 = create(:invoice, customer_id: customer.id, merchant_id: merchant_1.id)
    invoice_2 = create(:invoice, customer_id: customer.id, merchant_id: merchant_2.id)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id)
    transaction_2 = create(:transaction, invoice_id: invoice_2.id)

    get "/api/v1/customers/#{customer.id}/transactions"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(2)
  end
end
