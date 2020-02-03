class Api::V1::Merchants::RevenueController < ApplicationController
  def total_revenue
    revenue = sprintf('%.2f', Merchant.total_revenue(params[:id]))
    require "pry"; binding.pry
    revenue_hash = {:data => {:attributes => {revenue: total_revenue}}}
    render json: revenue_hash
  end
end
