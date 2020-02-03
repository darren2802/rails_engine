require 'rails_helper'

describe 'Invoice_items API' do
  it 'can send a list of invoice_items' do
    3.times do
      customer_id = create(:customer).id
      merchant_id = create(:merchant).id
      invoice_id = create(:invoice, customer_id: customer_id, merchant_id: merchant_id).id
      item_id = create(:item, merchant_id: merchant_id).id
      create(:invoice_item, invoice_id: invoice_id, item_id: item_id)
    end

    get '/api/v1/invoice_items'
    invoice_items = JSON.parse(response.body)
    expect(invoice_items['data'].count).to eq(3)
  end

  it 'can send a particular invoice item' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice_id = create(:invoice, customer_id: customer_id, merchant_id: merchant_id).id
    item_id = create(:item, merchant_id: merchant_id).id
    inv_item = create(:invoice_item, invoice_id: invoice_id, item_id: item_id)

    get "/api/v1/invoice_items/#{inv_item.id}"
    expect(response).to be_successful
    invoice_item = JSON.parse(response.body)
    expect(invoice_item['data']['attributes']['item_id']).to eq(item_id)
    expect(invoice_item['data']['attributes']['invoice_id']).to eq(invoice_id)
    expect(invoice_item['data']['attributes']['quantity']).to eq(inv_item.quantity)
    expect(invoice_item['data']['attributes']['unit_price']).to eq((inv_item.unit_price.to_f / 100).to_s)
  end

  it 'can send an associated invoice for an invoice_item' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice = create(:invoice, customer_id: customer_id, merchant_id: merchant_id)
    item_id = create(:item, merchant_id: merchant_id).id
    inv_item = create(:invoice_item, invoice_id: invoice.id, item_id: item_id)

    get "/api/v1/invoice_items/#{inv_item.id}/invoice"
    expect(response).to be_successful
    invoice_json = JSON.parse(response.body)
    expect(invoice_json['data']['attributes']['status']).to eq(invoice.status)
  end

  it 'can send an associated item for an invoice_item' do
    customer_id = create(:customer).id
    merchant_id = create(:merchant).id
    invoice_id = create(:invoice, customer_id: customer_id, merchant_id: merchant_id).id
    item = create(:item, merchant_id: merchant_id)
    inv_item = create(:invoice_item, invoice_id: invoice_id, item_id: item.id)

    get "/api/v1/invoice_items/#{inv_item.id}/item"
    expect(response).to be_successful
    item_json = JSON.parse(response.body)
    expect(item_json['data']['attributes']['name']).to eq(item.name)
    expect(item_json['data']['attributes']['description']).to eq(item.description)
    expect(item_json['data']['attributes']['unit_price']).to eq((item.unit_price.to_f / 100).to_s)
  end

  it 'can send an invoice_item when finding by:
        id, item_id, invoice_id, quantity, unit_price, date created or date updated' do
    customer = create(:customer)
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id, unit_price: 5525)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    invoice_item = create(:invoice_item, item_id: item.id, invoice_id: invoice.id, unit_price: 5525, created_at: "2020-01-31", updated_at: "2020-02-01")

    # find invoice_item by id
    get "/api/v1/invoice_items/find?id=#{invoice_item.id}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_item_json['data']['attributes']['id']).to eq(invoice_item.id)

    # find invoice_item by item_id
    get "/api/v1/invoice_items/find?item_id=#{invoice_item.item_id}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_item_json['data']['attributes']['id']).to eq(invoice_item.id)
    expect(invoice_item_json['data']['attributes']['item_id']).to eq(invoice_item.item_id)

    # find invoice_item by invoice_id
    get "/api/v1/invoice_items/find?invoice_id=#{invoice_item.invoice_id}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_item_json['data']['attributes']['id']).to eq(invoice_item.id)
    expect(invoice_item_json['data']['attributes']['invoice_id']).to eq(invoice_item.invoice_id)

    # find invoice_item by quantity
    get "/api/v1/invoice_items/find?quantity=#{invoice_item.quantity}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_item_json['data']['attributes']['id']).to eq(invoice_item.id)
    expect(invoice_item_json['data']['attributes']['quantity']).to eq(invoice_item.quantity)

    # find invoice_item by unit_price
    get "/api/v1/invoice_items/find?unit_price=55.25"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_item_json['data']['attributes']['id']).to eq(invoice_item.id)
    expect(invoice_item_json['data']['attributes']['unit_price']).to eq("55.25")

    # find invoice_item by created_at
    get "/api/v1/invoice_items/find?created_at=#{"2020-01-31"}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_item_json['data']['attributes']['id']).to eq(invoice_item.id)

    # find invoice_item by updated_at
    get "/api/v1/invoice_items/find?updated_at=#{"2020-02-01"}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_item_json['data']['attributes']['id']).to eq(invoice_item.id)
  end

  it 'can send invoice_items when finding all by:
        id, invoice_id, credit_card_number, result, date created or date updated' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    item = create(:item, merchant_id: merchant.id, unit_price: 5525)
    invoice_item_1 = create(:invoice_item, id: 3, item_id: item.id, invoice_id: invoice.id, unit_price: 5525, created_at: "2020-01-31", updated_at: "2020-02-01")
    invoice_item_2 = create(:invoice_item, item_id: item.id, invoice_id: invoice.id, unit_price: 5525, created_at: "2020-01-31", updated_at: "2020-02-01")
    invoice_item_3 = create(:invoice_item, id: 33, item_id: item.id, invoice_id: invoice.id, unit_price: 5525, created_at: "2020-01-31", updated_at: "2020-02-01")

    # find_all by id
    get "/api/v1/invoice_items/find_all?id=3"
    expect(response).to be_successful
    invoice_items_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(1)

    # find_all by item_id
    get "/api/v1/invoice_items/find_all?item_id=#{item.id}"
    expect(response).to be_successful
    invoice_items_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(3)

    # find_all by invoice_id
    get "/api/v1/invoice_items/find_all?invoice_id=#{invoice.id}"
    expect(response).to be_successful
    invoice_items_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(3)

    # find_all by quantity
    get "/api/v1/invoice_items/find_all?quantity=#{invoice_item_1.quantity}"
    expect(response).to be_successful
    invoice_items_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(3)

    # find invoice_item by unit_price
    get "/api/v1/invoice_items/find_all?unit_price=55.25"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(3)

    # find_all by created_at
    get "/api/v1/invoice_items/find_all?created_at=#{"2020-01-31"}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(3)

    # find_all by updated_at
    get "/api/v1/invoice_items/find_all?updated_at=#{"2020-02-01"}"
    expect(response).to be_successful
    invoice_item_json = JSON.parse(response.body)
    expect(invoice_items_json['data'].count).to eq(3)
  end

  it 'can send a random invoice_item' do
    customer = create(:customer)
    merchant = create(:merchant)
    invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
    item = create(:item, merchant_id: merchant.id, unit_price: 5525)
    invoice_items = create_list(:invoice_item, 3, item_id: item.id, invoice_id: invoice.id)

    get "/api/v1/invoice_items/random"
    expect(response).to be_successful
    invoice_items_json = JSON.parse(response.body)
    expect(invoice_items.any? { |invoice_item| invoice_items_json['data']['attributes']['id'] }).to be true
  end
end
