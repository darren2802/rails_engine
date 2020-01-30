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
end
