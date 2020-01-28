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
end
