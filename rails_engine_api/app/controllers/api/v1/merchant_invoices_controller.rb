class Api::V1::MerchantInvoicesController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Invoice.where(merchant_id: params[:id]))
  end
end
