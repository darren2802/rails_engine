class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  belongs_to :merchant

  def self.most_revenue(quantity)
    select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price / 100)::float as total_revenue')
    .joins(:invoice_items)
    .group(:id)
    .order('total_revenue DESC')
    .limit(quantity)
  end
end
