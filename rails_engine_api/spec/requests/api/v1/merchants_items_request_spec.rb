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
end
