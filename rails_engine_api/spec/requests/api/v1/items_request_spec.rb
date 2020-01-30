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

  it 'can send the top x items ranked by total revenue generated' do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id, unit_price: 100)
    item_2 = create(:item, merchant_id: merchant.id, unit_price: 200)
    item_3 = create(:item, merchant_id: merchant.id, unit_price: 300)
    customer = create(:customer)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice.id, unit_price: 100, quantity: 10)
    invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice.id, unit_price: 200, quantity: 20)
    invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice.id, unit_price: 300, quantity: 30)

    get '/api/v1/items/most_revenue?quantity=1'
    expect(response).to be_successful
    item_json = JSON.parse(response.body)
    expect(item_json['data'][0]['id']).to eq(item_3.id.to_s)
  end

  it 'can send the date with the most sales for the given item using the invoice date' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id, unit_price: 1000)
    customer = create(:customer)

    invoice_1 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, created_at: "2020-01-05")
    invoice_item_1 = create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 1000, created_at: "2020-01-05")

    invoice_2 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, created_at: "2020-01-10")
    invoice_item_2 = create(:invoice_item, item_id: item.id, invoice_id: invoice_2.id, quantity: 30, unit_price: 1000, created_at: "2020-01-10")

    invoice_3 = create(:invoice, customer_id: customer.id, merchant_id: merchant.id, created_at: "2020-01-15")
    invoice_item_3 = create(:invoice_item, item_id: item.id, invoice_id: invoice_3.id, quantity: 20, unit_price: 1000, created_at: "2020-01-15")

    get "/api/v1/items/#{item.id}/best_day"
    expect(response).to be_successful
    best_day_json = JSON.parse(response.body)
    expect(best_day_json['data']['attributes']['best_day']).to eq("2020-01-10")
  end
end
