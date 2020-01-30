class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def most_revenue
    render json: ItemSerializer.new(Item.most_revenue(params[:quantity]))
  end

  def best_day
    # day = InvoiceItem.best_day(params[:id])[0].best_day.to_s
    best_day = InvoiceItem.best_day(params[:id])
    best_day_hash = {'data' => {'attributes' => {'best_day' => best_day}}}
    render json: best_day_hash
  end
end
