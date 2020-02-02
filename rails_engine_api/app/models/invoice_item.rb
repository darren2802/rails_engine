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

  def self.find_one(params)
    if params['id']
      where("(id = ?)", params[:id].to_i)
    elsif params['item_id']
      where("(item_id = ?)", params[:item_id].to_i)
    elsif params['invoice_id']
      where("(invoice_id = ?)", params[:invoice_id].to_i)
    elsif params['quantity']
      where("(quantity = ?)", params[:quantity].to_i)
    elsif params['unit_price']
      where('unit_price = ?', (params[:unit_price].to_f * 100).round(0))
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}").order(:id)
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}").order(:id)
    end
  end

  def self.find_all(params)
    if params['id']
      where("id = ?", params[:id].to_i)
    elsif params['item_id']
      where("item_id = ?", params[:item_id].to_i)
    elsif params['invoice_id']
      where("invoice_id = ?", params[:invoice_id].to_i)
    elsif params['quantity']
      where("quantity = ?", params[:quantity].to_i)
    elsif params['unit_price']
      where('unit_price = ?', (params[:unit_price].to_f * 100).round(0))      
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end
end
