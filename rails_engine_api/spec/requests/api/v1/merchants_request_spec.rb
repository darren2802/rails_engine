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

  it 'returns the top x merchants ranked by total revenue' do
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

  xit 'returns the total revenue for date x across all merchants' do
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

  end
end
