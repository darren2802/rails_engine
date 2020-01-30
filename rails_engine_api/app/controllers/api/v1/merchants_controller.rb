class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def most_revenue
    merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def revenue
    total_revenue = Invoice.revenue_by_date(params[:date])[0]['total_revenue']
    total_revenue_hash = {:data => {:attributes => {total_revenue: total_revenue.to_s}}}
    render json: total_revenue_hash
  end
end
