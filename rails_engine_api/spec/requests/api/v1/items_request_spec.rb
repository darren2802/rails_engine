require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)

    get '/api/v1/items'
    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items['data'].count).to eq(3)
  end

  it 'can send a particular item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}"
    expect(response).to be_successful
    item_json = JSON.parse(response.body)
    expect(item_json['data']['attributes']['name']).to eq(item.name)
    expect(item_json['data']['attributes']['description']).to eq(item.description)
    expect(item_json['data']['attributes']['unit_price']).to eq(item.unit_price)
  end
end
