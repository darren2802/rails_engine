class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price

  belongs_to :item
  belongs_to :invoice

  def self.best_day(item_id)
    select('invoices.created_at::date as best_day, SUM(invoice_items.quantity * invoice_items.unit_price / 100)::float as total_revenue')
    .joins(:invoice, :item)
    .where('items.id = ?', item_id)
    .group('invoices.created_at')
    .order('total_revenue DESC, invoices.created_at DESC')
    .limit(1)[0].best_day.to_s
  end
end
