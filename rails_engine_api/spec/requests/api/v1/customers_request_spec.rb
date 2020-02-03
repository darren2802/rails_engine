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

  it 'can send a collection of associated transactions for a customer' do
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

  it 'can send a merchant where the customer has conducted the most successful transactions' do
    customer = create(:customer)

    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)
    merchant_4 = create(:merchant)

    invoice_1 = create(:invoice, customer_id: customer.id, merchant_id: merchant_1.id)
    transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: "success")

    invoice_2 = create(:invoice, customer_id: customer.id, merchant_id: merchant_2.id)
    transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: "success")
    invoice_22 = create(:invoice, customer_id: customer.id, merchant_id: merchant_2.id)
    transaction_22 = create(:transaction, invoice_id: invoice_22.id, result: "success")
    invoice_23 = create(:invoice, customer_id: customer.id, merchant_id: merchant_2.id)
    transaction_23 = create(:transaction, invoice_id: invoice_23.id, result: "failed")

    invoice_3 = create(:invoice, customer_id: customer.id, merchant_id: merchant_3.id)
    transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: "success")

    invoice_4 = create(:invoice, customer_id: customer.id, merchant_id: merchant_4.id)
    transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: "success")
    invoice_42 = create(:invoice, customer_id: customer.id, merchant_id: merchant_4.id)
    transaction_42 = create(:transaction, invoice_id: invoice_42.id, result: "failed")

    get "/api/v1/customers/#{customer.id}/favorite_merchant"
    expect(response).to be_successful
    favorite_merchant_json = JSON.parse(response.body)
    expect(favorite_merchant_json['data']['attributes']['name']).to eq(merchant_2.name)
  end

  it 'can send a customer when finding by:
        id, first_name, last_name, date created or date updated' do
    customer = create(:customer, created_at: "2020-01-31", updated_at: "2020-02-01")

    # find customer by id
    get "/api/v1/customers/find?id=#{customer.id}"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customer_json['data']['attributes']['id']).to eq(customer.id)

    # find customer by first_name
    get "/api/v1/customers/find?first_name=#{customer.first_name}"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customer_json['data']['attributes']['id']).to eq(customer.id)
    expect(customer_json['data']['attributes']['first_name']).to eq(customer.first_name)

    # find customer by last_name
    get "/api/v1/customers/find?last_name=#{customer.last_name}"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customer_json['data']['attributes']['id']).to eq(customer.id)
    expect(customer_json['data']['attributes']['last_name']).to eq(customer.last_name)

    # find customer by created_at
    get "/api/v1/customers/find?created_at=#{"2020-01-31"}"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customer_json['data']['attributes']['id']).to eq(customer.id)

    # find customer by updated_at
    get "/api/v1/customers/find?updated_at=#{"2020-02-01"}"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customer_json['data']['attributes']['id']).to eq(customer.id)
  end

  it 'can send customers when finding all by:
        id, first_name, last_name, date created or date updated' do
    customer_1 = create(:customer, id: 3, created_at: "2020-01-31", updated_at: "2020-02-01")
    customer_2 = create(:customer, created_at: "2020-01-31", updated_at: "2020-02-01")
    customer_3 = create(:customer, id: 33, created_at: "2020-01-31", updated_at: "2020-02-01")

    # find_all by id
    get "/api/v1/customers/find_all?id=3"
    expect(response).to be_successful
    customers_json = JSON.parse(response.body)
    expect(customers_json['data'].count).to eq(2)

    # find_all by first_name
    get "/api/v1/customers/find_all?first_name=#{customer_1.first_name}"
    expect(response).to be_successful
    customers_json = JSON.parse(response.body)
    expect(customers_json['data'].count).to eq(3)

    # find_all by last_name
    get "/api/v1/customers/find_all?last_name=#{customer_1.last_name}"
    expect(response).to be_successful
    customers_json = JSON.parse(response.body)
    expect(customers_json['data'].count).to eq(3)

    # find_all by created_at
    get "/api/v1/customers/find_all?created_at=#{"2020-01-31"}"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customers_json['data'].count).to eq(3)

    # find_all by updated_at
    get "/api/v1/customers/find_all?updated_at=#{"2020-02-01"}"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customers_json['data'].count).to eq(3)
  end

  it 'can send a random customer' do
    customers = create_list(:customer, 3)

    get "/api/v1/customers/random"
    expect(response).to be_successful
    customers_json = JSON.parse(response.body)
    expect(customers.any? { |customer| customers_json['data']['attributes']['id'] }).to be true
  end
end
