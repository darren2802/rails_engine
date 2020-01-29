require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'
    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(5)
  end

  it 'returns the top x merchants ranked by total revenue' do
    customer_id_1 = create(:customer).id
    merchant_id_1 = create(:merchant).id
    invoice_id_1 = create(:invoice, customer_id: customer_id_1, merchant_id: merchant_id_1).id
    item_id_1 = create(:item, merchant_id: merchant_id_1).id
    create_list(:invoice_item, 5, invoice_id: invoice_id_1, item_id: item_id_1)

    customer_id_2 = create(:customer).id
    merchant_id_2 = create(:merchant).id
    invoice_id_2 = create(:invoice, customer_id: customer_id_2, merchant_id: merchant_id_2).id
    item_id_2 = create(:item, merchant_id: merchant_id_2).id
    create_list(:invoice_item, 5, invoice_id: invoice_id_2, item_id: item_id_2)

    customer_id_3 = create(:customer).id
    merchant_id_3 = create(:merchant).id
    invoice_id_3 = create(:invoice, customer_id: customer_id_3, merchant_id: merchant_id_3).id
    item_id_3 = create(:item, merchant_id: merchant_id_3).id
    create_list(:invoice_item, 5, invoice_id: invoice_id_3, item_id: item_id_3)

    get '/api/v1/merchants/most_revenue?quantity=2'
    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants['data'].count).to eq(2)
  end
end
