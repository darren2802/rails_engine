class Api::V1::InvoiceItems::FindController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.find_all(params))
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find_one(params)[0])
  end

  def random
    render json: InvoiceItemSerializer.new(InvoiceItem.find(InvoiceItem.pluck(:id).sample))
  end
end
