class Api::V1::Invoices::FindController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Invoice.find_all(params))
  end

  def show
    render json: InvoiceSerializer.new(Invoice.find_one(params)[0])
  end

  def random
    render json: InvoiceSerializer.new(Invoice.find(Item.pluck(:id).sample))
  end
end
