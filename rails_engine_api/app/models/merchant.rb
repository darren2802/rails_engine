class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices

  def self.most_revenue(quantity)
    select("merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price / 100) as revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order('revenue DESC')
    .limit(quantity)
  end
end
