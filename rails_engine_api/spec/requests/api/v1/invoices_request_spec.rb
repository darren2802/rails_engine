require 'rails_helper'

describe 'Invoices API' do
  it 'sends a list of invoices' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    create_list(:invoice, 5, customer_id: customer_id, merchant_id: merchant_id)

    get '/api/v1/invoices'
    expect(response).to be_successful
    invoices = JSON.parse(response.body)
    expect(invoices['data'].count).to eq(5)
  end

  it 'can send a particular invoice' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice = create(:invoice, customer_id: customer_id, merchant_id: merchant_id)

    get "/api/v1/invoices/#{invoice.id}"
    expect(response).to be_successful
    invoice_json = JSON.parse(response.body)
    expect(invoice_json['data']['attributes']['status']).to eq(invoice.status)
  end
end
