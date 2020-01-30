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
    expect(item_json['data']['attributes']['unit_price']).to eq((item.unit_price.to_f / 100).to_s)
  end

  it 'can send a collection of associated invoice_items for an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    invoice_1 = create(:invoice, customer_id: customer_1.id, merchant_id: merchant.id)
    invoice_2 = create(:invoice, customer_id: customer_2.id, merchant_id: merchant.id)
    invoice_3 = create(:invoice, customer_id: customer_3.id, merchant_id: merchant.id)
    invoice_item_1 = create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id)
    invoice_item_2 = create(:invoice_item, item_id: item.id, invoice_id: invoice_2.id)
    invoice_item_3 = create(:invoice_item, item_id: item.id, invoice_id: invoice_3.id)

    get "/api/v1/items/#{item.id}/invoice_items"

    expect(response).to be_successful
    invoice_items_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(3)
  end

  it 'can send an associated merchant for an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"
    expect(response).to be_successful
    merchant_json = JSON.parse(response.body)
    expect(merchant_json['data']['attributes']['name']).to eq(merchant.name)
  end
end
