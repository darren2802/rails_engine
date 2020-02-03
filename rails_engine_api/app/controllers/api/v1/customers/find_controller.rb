class Api::V1::Customers::FindController < ApplicationController
  def index
    render json: CustomerSerializer.new(Customer.find_all(params))
  end

  def show
    render json: CustomerSerializer.new(Customer.find_one(params)[0])
  end

  def random
    render json: CustomerSerializer.new(Customer.find(Customer.pluck(:id).sample))
  end
end
