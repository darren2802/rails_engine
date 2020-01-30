require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    create_list(:customer, 5)

    get '/api/v1/customers'
    expect(response).to be_successful
    customers = JSON.parse(response.body)
    expect(customers['data'].count).to eq(5)
  end

  it 'sends a particular customer' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)

    get "/api/v1/customers/#{customer_2.id}"
    expect(response).to be_successful
    customer = JSON.parse(response.body)
    expect(customer['data']['attributes']['first_name']).to eq(customer_2.first_name)
    expect(customer['data']['attributes']['last_name']).to eq(customer_2.last_name)
  end
end
