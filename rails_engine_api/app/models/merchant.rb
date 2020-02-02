class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices

  def self.most_revenue(quantity)
    select("merchants.id, merchants.name, merchants.created_at, merchants.updated_at, sum(invoice_items.quantity * invoice_items.unit_price / 100) as revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order('revenue DESC')
    .limit(quantity)
  end

  def self.favorite_merchant(customer_id)
    select('merchants.*, COUNT(*)')
    .joins(invoices: :transactions)
    .where('invoices.customer_id=?', customer_id)
    .group(:id)
    .merge(Transaction.successful)
    .order('count DESC')
    .limit(1)[0]
  end

  def self.total_revenue(merchant_id)
    revenue = select('SUM(invoice_items.quantity * invoice_items.unit_price / 100) as revenue')
      .joins(invoices: [:invoice_items, :transactions])
      .group(:id).where('merchants.id = ?', merchant_id)
      .merge(Transaction.successful)[0].revenue
    require "pry"; binding.pry
  end

  def self.find_one(params)
    if params['id']
      where("(id = ?)", params[:id].to_i)
    elsif params['name']
      where('LOWER(name) = ?', params[:name].downcase)
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end

  def self.find_all(params)
    if params['id']
      where("(id::text LIKE ?)", "%#{params[:id]}%")
    elsif params['name']
      where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%")
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end
end
