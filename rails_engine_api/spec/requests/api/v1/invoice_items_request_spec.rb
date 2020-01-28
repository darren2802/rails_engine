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
end
