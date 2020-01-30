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
end
