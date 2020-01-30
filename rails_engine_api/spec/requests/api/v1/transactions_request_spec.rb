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
end
