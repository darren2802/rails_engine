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

  it 'can send a list of associated transactions for an invoice' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice = create(:invoice, customer_id: customer_id, merchant_id: merchant_id)
    transactions = create_list(:transaction, 5, invoice_id: invoice.id)

    get "/api/v1/invoices/#{invoice.id}/transactions"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(5)
  end

  it 'can send a list of associated invoice_items for an invoice' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice = create(:invoice, customer_id: customer_id, merchant_id: merchant_id)
    item_1 = create(:item, merchant_id: merchant_id)
    invoice_item_1 = create(:invoice_item, invoice_id: invoice.id, item_id: item_1.id)
    item_2 = create(:item, merchant_id: merchant_id)
    invoice_item_2 = create(:invoice_item, invoice_id: invoice.id, item_id: item_2.id)

    get "/api/v1/invoices/#{invoice.id}/invoice_items"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(2)
  end

  it 'can send a list of associated items for an invoice' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice = create(:invoice, customer_id: customer_id, merchant_id: merchant_id)
    item_1 = create(:item, merchant_id: merchant_id)
    invoice_item_1 = create(:invoice_item, invoice_id: invoice.id, item_id: item_1.id)
    item_2 = create(:item, merchant_id: merchant_id)
    invoice_item_2 = create(:invoice_item, invoice_id: invoice.id, item_id: item_2.id)

    get "/api/v1/invoices/#{invoice.id}/items"
    expect(response).to be_successful
    transactions_json = JSON.parse(response.body)
    expect(transactions_json['data'].count).to eq(2)
  end

  it 'can send an associated customer for an invoice' do
    customer = create(:customer)
    merchant_id = create(:merchant).id
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant_id)
    item_1 = create(:item, merchant_id: merchant_id)
    invoice_item_1 = create(:invoice_item, invoice_id: invoice.id, item_id: item_1.id)

    get "/api/v1/invoices/#{invoice.id}/customer"
    expect(response).to be_successful
    merchant_json = JSON.parse(response.body)
    expect(merchant_json['data']['attributes']['first_name']).to eq(customer.first_name)
    expect(merchant_json['data']['attributes']['last_name']).to eq(customer.last_name)
  end

  it 'can send an associated merchant for an invoice' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    item_1 = create(:item, merchant_id: merchant.id)
    invoice_item_1 = create(:invoice_item, invoice_id: invoice.id, item_id: item_1.id)

    get "/api/v1/invoices/#{invoice.id}/merchant"
    expect(response).to be_successful
    merchant_json = JSON.parse(response.body)
    expect(merchant_json['data']['attributes']['name']).to eq(merchant.name)
  end
end
