class Api::V1::Merchants::FindController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_all(params))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find_one(params)[0])
  end

  def random
    render json: MerchantSerializer.new(Merchant.find(Merchant.pluck(:id).sample))
  end
end
