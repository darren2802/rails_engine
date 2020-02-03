class Api::V1::Transactions::FindController < ApplicationController
  def index
    render json: TransactionSerializer.new(Transaction.find_all(params))
  end

  def show
    render json: TransactionSerializer.new(Transaction.find_one(params)[0])
  end

  def random
    render json: TransactionSerializer.new(Transaction.find(Transaction.pluck(:id).sample))
  end
end
