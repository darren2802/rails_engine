require 'rails_helper'

describe 'Merchant items API' do
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
end
