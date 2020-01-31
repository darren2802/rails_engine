class Invoice < ApplicationRecord
  validates_presence_of :status

  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  belongs_to :customer
  belongs_to :merchant

  def self.revenue_by_date(date)
    select('sum(quantity * unit_price)::float/100 as total_revenue')
    .joins(:invoice_items, :transactions)
    .merge(Transaction.successful)
    .where("invoices.created_at::date::text = ?", date)[0]['total_revenue']
  end

  def self.favorite_customer(merchant_id)
    Invoice.joins(:customer, :transactions)
            .select('customers.*, COUNT(*)')
            .where('invoices.merchant_id = ?', merchant_id)
            .group('customers.id')
            .merge(Transaction.successful)
            .order('count DESC').limit(1)[0]
  end
end
