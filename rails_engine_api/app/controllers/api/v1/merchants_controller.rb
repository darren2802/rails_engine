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
    total_revenue = sprintf('%.2f', Invoice.revenue_by_date(params[:date]))
    total_revenue_hash = {:data => {:attributes => {total_revenue: total_revenue}}}
    render json: total_revenue_hash
  end

  def favorite_customer
    render json: CustomerSerializer.new(Invoice.favorite_customer(params[:id]))
  end

  def favorite_merchant
    render json: MerchantSerializer.new(Merchant.favorite_merchant(params[:id]))
  end

  def pending_invoices
    render json: CustomerSerializer.new(Customer.pending_invoices(params[:id]))
  end
end
