require 'rails_helper'

describe 'Transactions API' do
  it 'sends a list of invoices' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice_id = create(:invoice, customer_id: customer_id, merchant_id: merchant_id).id
    create_list(:transaction, 5, invoice_id: invoice_id)

    get '/api/v1/transactions'
    expect(response).to be_successful
    transactions = JSON.parse(response.body)
    expect(transactions['data'].count).to eq(5)
  end

  it 'can send a particular transaction' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice_id = create(:invoice, customer_id: customer_id, merchant_id: merchant_id).id
    transaction = create(:transaction, invoice_id: invoice_id)

    get "/api/v1/transactions/#{transaction.id}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transaction_json['data']['attributes']['credit_card_number']).to eq(transaction.credit_card_number)
    expect(transaction_json['data']['attributes']['result']).to eq(transaction.result)
  end

  it 'can send an associated invoice for a transaction' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice = create(:invoice, customer_id: customer_id, merchant_id: merchant_id)
    transaction = create(:transaction, invoice_id: invoice.id)

    get "/api/v1/transactions/#{transaction.id}/invoice"
    expect(response).to be_successful
    invoice_json = JSON.parse(response.body)
    expect(invoice_json['data']['attributes']['customer_id']).to eq(customer_id)
    expect(invoice_json['data']['attributes']['merchant_id']).to eq(merchant_id)
    expect(invoice_json['data']['attributes']['status']).to eq(invoice.status)
  end

  it 'can send a transaction when finding by:
        id, invoice_id, credit_card_number, result, date created or date updated' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    transaction = create(:transaction, invoice_id: invoice.id, created_at: "2020-01-31", updated_at: "2020-02-01")

    # find transaction by id
    get "/api/v1/transactions/find?id=#{transaction.id}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transaction_json['data']['attributes']['id']).to eq(transaction.id)

    # find transaction by invoice_id
    get "/api/v1/transactions/find?invoice_id=#{transaction.invoice_id}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transaction_json['data']['attributes']['id']).to eq(transaction.id)
    expect(transaction_json['data']['attributes']['invoice_id']).to eq(transaction.invoice_id)

    # find transaction by credit_card_number
    get "/api/v1/transactions/find?credit_card_number=#{transaction.credit_card_number}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transaction_json['data']['attributes']['id']).to eq(transaction.id)
    expect(transaction_json['data']['attributes']['credit_card_number']).to eq(transaction.credit_card_number)

    # find transaction by result
    get "/api/v1/transactions/find?result=#{transaction.result}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transaction_json['data']['attributes']['id']).to eq(transaction.id)
    expect(transaction_json['data']['attributes']['result']).to eq(transaction.result)

    # find transaction by created_at
    get "/api/v1/transactions/find?created_at=#{"2020-01-31"}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transaction_json['data']['attributes']['id']).to eq(transaction.id)

    # find transaction by updated_at
    get "/api/v1/transactions/find?updated_at=#{"2020-02-01"}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transaction_json['data']['attributes']['id']).to eq(transaction.id)
  end

  it 'can send transactions when finding all by:
        id, invoice_id, credit_card_number, result, date created or date updated' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    transaction_1 = create(:transaction, id: 3, invoice_id: invoice.id, created_at: "2020-01-31", updated_at: "2020-02-01")
    transaction_2 = create(:transaction, invoice_id: invoice.id, created_at: "2020-01-31", updated_at: "2020-02-01")
    transaction_3 = create(:transaction, id: 33, invoice_id: invoice.id, created_at: "2020-01-31", updated_at: "2020-02-01")

    # find_all by id
    get "/api/v1/transactions/find_all?id=3"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(1)

    # find_all by invoice_id
    get "/api/v1/transactions/find_all?invoice_id=#{invoice.id}"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(3)

    # find_all by credit_card_number
    get "/api/v1/transactions/find_all?credit_card_number=#{transaction_1.credit_card_number}"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(3)

    # find_all by result
    get "/api/v1/transactions/find_all?result=#{transaction_1.result}"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(3)

    # find_all by created_at
    get "/api/v1/transactions/find_all?created_at=#{"2020-01-31"}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(3)

    # find_all by updated_at
    get "/api/v1/transactions/find_all?updated_at=#{"2020-02-01"}"
    expect(response).to be_successful
    transaction_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(3)
  end

  it 'can send a random transaction' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    transactions = create_list(:transaction, 3, invoice_id: invoice.id)

    get "/api/v1/transactions/random"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions.any? { |transaction| transactions_json['data']['attributes']['id'] }).to be true
  end
end
