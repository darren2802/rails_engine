require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'
    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(5)
  end

  it 'sends a particular merchant' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/#{merchant_2.id}"
    expect(response).to be_successful

    merchant = JSON.parse(response.body)
    expect(merchant['data']['attributes']['id']).to eq(merchant_2.id)
    expect(merchant['data']['attributes']['name']).to eq(merchant_2.name)
  end

  it 'can send a list of items for a particular merchant' do
    merchant_id_1 = create(:merchant).id
    create_list(:item, 4, merchant_id: merchant_id_1)
    merchant_id_2 = create(:merchant).id
    create_list(:item, 2, merchant_id: merchant_id_2)

    get "/api/v1/merchants/#{merchant_id_2}/items"
    expect(response).to be_successful
    merchant_items = JSON.parse(response.body)
    expect(merchant_items['data'].count).to eq(2)
  end

  it 'can send a list of invoices for a particular merchant' do
    customer_id = create(:customer).id
    merchant_id_1 = create(:merchant).id
    create_list(:invoice, 3, customer_id: customer_id, merchant_id: merchant_id_1)
    merchant_id_2 = create(:merchant).id
    create_list(:invoice, 5, customer_id: customer_id, merchant_id: merchant_id_2)

    get "/api/v1/merchants/#{merchant_id_2}/invoices"
    expect(response).to be_successful
    merchant_invoices = JSON.parse(response.body)
    expect(merchant_invoices['data'].count).to eq(5)
  end

  it 'can send a merchant when finding by merchant id, name, date created or date updated' do
    merchant = create(:merchant)
    created_at = merchant.created_at.strftime("%Y-%m-%dT%H:%M:%S.000Z")

    # find merchant by id
    get "/api/v1/merchants/find?id=#{merchant.id}"
    expect(response).to be_successful
    merchant_json = JSON.parse(response.body)
    expect(merchant_json['data']['attributes']['id']).to eq(merchant.id)
    expect(merchant_json['data']['attributes']['name']).to eq(merchant.name)

    # find merchant by name
    get "/api/v1/merchants/find?name=#{merchant.name}"
    expect(response).to be_successful
    merchant_json = JSON.parse(response.body)
    expect(merchant_json['data']['attributes']['id']).to eq(merchant.id)
    expect(merchant_json['data']['attributes']['name']).to eq(merchant.name)

    # find merchant by created_at
    # get "/api/v1/merchants/find?created_at=#{created_at}"
    # expect(response).to be_successful
    # merchant_json = JSON.parse(response.body)
    # expect(merchant_json['data']['attributes']['id']).to eq(merchant.id)
    # expect(merchant_json['data']['attributes']['name']).to eq(merchant.name)

    # find merchant by updated_at
    # get "/api/v1/merchants/find?id=#{merchant.updated_at}"
    # expect(response).to be_successful
    # merchant_json = JSON.parse(response.body)
    # expect(merchant_json['data']['attributes']['id']).to eq(merchant.id)
    # expect(merchant_json['data']['attributes']['name']).to eq(merchant.name)
  end

  it 'can send merchants when finding all by merchant id, name, created_at, or updated at' do
    merchant_1 = create(:merchant, id: 3, name: "Schroeder-Jerde")
    merchant_2 = create(:merchant, id: 4, name: "Smith-Jerde")
    merchant_3 = create(:merchant, id: 33, name: "Cummings-Thiel")

    # find_all by id
    get "/api/v1/merchants/find_all?id=3"
    expect(response).to be_successful
    merchants_json = JSON.parse(response.body)
    expect(merchants_json['data'].count).to eq(2)

    # find_all by name
    get "/api/v1/merchants/find_all?name=jerde"
    expect(response).to be_successful
    merchants_json = JSON.parse(response.body)
    expect(merchants_json['data'].count).to eq(2)
  end

  it 'can send a random merchant' do
    merchants = create_list(:merchant, 3)

    get "/api/v1/merchants/random"
    expect(response).to be_successful
    merchants_json = JSON.parse(response.body)
    expect(merchants.any? { |merchant| merchants_json['data']['attributes']['id'] }).to be true
  end

  it 'can send the top x merchants ranked by total revenue' do
    customer_id_1 = create(:customer).id
    merchant_id_1 = create(:merchant).id
    invoice_id_1 = create(:invoice, customer_id: customer_id_1, merchant_id: merchant_id_1).id
    transaction_1 = create(:transaction, invoice_id: invoice_id_1, result: "success")
    item_id_1 = create(:item, merchant_id: merchant_id_1).id
    create_list(:invoice_item, 5, invoice_id: invoice_id_1, item_id: item_id_1)

    customer_id_2 = create(:customer).id
    merchant_id_2 = create(:merchant).id
    invoice_id_2 = create(:invoice, customer_id: customer_id_2, merchant_id: merchant_id_2).id
    transaction_2 = create(:transaction, invoice_id: invoice_id_2, result: "success")
    item_id_2 = create(:item, merchant_id: merchant_id_2).id
    create_list(:invoice_item, 5, invoice_id: invoice_id_2, item_id: item_id_2)

    customer_id_3 = create(:customer).id
    merchant_id_3 = create(:merchant).id
    invoice_id_3 = create(:invoice, customer_id: customer_id_3, merchant_id: merchant_id_3).id
    transaction_3 = create(:transaction, invoice_id: invoice_id_3, result: "success")
    item_id_3 = create(:item, merchant_id: merchant_id_3).id
    create_list(:invoice_item, 5, invoice_id: invoice_id_3, item_id: item_id_3)

    get '/api/v1/merchants/most_revenue?quantity=2'
    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(2)
  end

  it 'can send the total revenue for date x across all merchants' do
    customer_id_1 = create(:customer).id
    merchant_id_1 = create(:merchant).id
    invoice_id_1 = create(:invoice, customer_id: customer_id_1, merchant_id: merchant_id_1, created_at: "2020-01-15").id
    transaction_1 = create(:transaction, invoice_id: invoice_id_1, result: "success", created_at: "2020-01-15")
    item_id_1 = create(:item, merchant_id: merchant_id_1).id
    create(:invoice_item, invoice_id: invoice_id_1, item_id: item_id_1, created_at: "2020-01-15", unit_price: 1000, quantity: 10)

    customer_id_2 = create(:customer).id
    merchant_id_2 = create(:merchant).id
    invoice_id_2 = create(:invoice, customer_id: customer_id_2, merchant_id: merchant_id_2, created_at: "2020-01-15").id
    transaction_2 = create(:transaction, invoice_id: invoice_id_2, result: "success", created_at: "2020-01-15")
    item_id_2 = create(:item, merchant_id: merchant_id_2).id
    create(:invoice_item, invoice_id: invoice_id_2, item_id: item_id_2, created_at: "2020-01-15", unit_price: 1000, quantity: 20)

    customer_id_3 = create(:customer).id
    merchant_id_3 = create(:merchant).id
    invoice_id_3 = create(:invoice, customer_id: customer_id_3, merchant_id: merchant_id_3, created_at: "2020-01-15").id
    transaction_3 = create(:transaction, invoice_id: invoice_id_3, result: "success", created_at: "2020-01-15")
    item_id_3 = create(:item, merchant_id: merchant_id_3).id
    create(:invoice_item, invoice_id: invoice_id_3, item_id: item_id_3, created_at: "2020-01-15", unit_price: 1000, quantity: 20)

    get '/api/v1/merchants/revenue?date=2020-01-15'
    expect(response).to be_successful
    total_revenue_json = JSON.parse(response.body)
    expect(total_revenue_json['data']['attributes']['total_revenue']).to eq("500.00")
  end

  it 'can send the customer who has conducted the most total number of successful transactions' do
    merchant_id = create(:merchant).id

    customer_id_1 = create(:customer).id
    invoice_id_1 = create(:invoice, customer_id: customer_id_1, merchant_id: merchant_id).id
    transaction_1 = create(:transaction, invoice_id: invoice_id_1, result: "success")

    customer_id_2 = create(:customer).id
    invoice_id_2 = create(:invoice, customer_id: customer_id_2, merchant_id: merchant_id).id
    transaction_2 = create(:transaction, invoice_id: invoice_id_2, result: "success")

    customer_3 = create(:customer)
    invoice_id_3 = create(:invoice, customer_id: customer_3.id, merchant_id: merchant_id).id
    invoice_id_4 = create(:invoice, customer_id: customer_3.id, merchant_id: merchant_id).id
    transaction_3 = create(:transaction, invoice_id: invoice_id_3, result: "success")
    transaction_4 = create(:transaction, invoice_id: invoice_id_4, result: "success")

    get "/api/v1/merchants/#{merchant_id}/favorite_customer"
    expect(response).to be_successful
    customer_json = JSON.parse(response.body)
    expect(customer_json['data']['attributes']['first_name']).to eq(customer_3.first_name)
    expect(customer_json['data']['attributes']['last_name']).to eq(customer_3.last_name)
  end

  it 'can send a collection of customers which have pending (unpaid) invoices' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}/customers_with_pending_invoices"
    expect(response).to be_successful
    customers_json = JSON.parse(response.body)
    expect(customers_json['data'].count).to eq(2)
  end

  xit 'can send the total revenue across all transactions associated with one merchant' do
    merchant = create(:merchant)

    customer_id_1 = create(:customer).id
    invoice_id_1 = create(:invoice, customer_id: customer_id_1, merchant_id: merchant.id).id
    transaction_1 = create(:transaction, invoice_id: invoice_id_1, result: "success")
    item_id_1 = create(:item, merchant_id: merchant.id).id
    create(:invoice_item, invoice_id: invoice_id_1, item_id: item_id_1, unit_price: 1000, quantity: 10)

    customer_id_2 = create(:customer).id
    invoice_id_2 = create(:invoice, customer_id: customer_id_2, merchant_id: merchant.id).id
    transaction_2 = create(:transaction, invoice_id: invoice_id_2, result: "success")
    item_id_2 = create(:item, merchant_id: merchant.id).id
    create(:invoice_item, invoice_id: invoice_id_2, item_id: item_id_2, unit_price: 1000, quantity: 20)

    customer_id_3 = create(:customer).id
    invoice_id_3 = create(:invoice, customer_id: customer_id_3, merchant_id: merchant.id).id
    transaction_3 = create(:transaction, invoice_id: invoice_id_3, result: "success")
    item_id_3 = create(:item, merchant_id: merchant.id).id
    create(:invoice_item, invoice_id: invoice_id_3, item_id: item_id_3, unit_price: 1000, quantity: 20)

    get "/merchants/#{merchant.id}/revenue"
    expect(response).to be_successful
    revenue_json = JSON.parse(response.body)
    expect(revenue_json['data']['attributes']['revenue']).to eq("500.00")
  end
end
