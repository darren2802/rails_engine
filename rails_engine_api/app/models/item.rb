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

  def self.find_one(params)
    if params['id']
      where("(id = ?)", params[:id].to_i)
    elsif params['name']
      where('LOWER(name) = ?', params[:name].downcase)
    elsif params['description']
      where('LOWER(description) = ?', params[:description].downcase)
    elsif params['unit_price']
      where('unit_price = ?', (params[:unit_price].to_f * 100).round(0))
    elsif params['merchant_id']
      where('merchant_id = ?', params[:merchant_id].to_i)
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}").order(:id)
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}").order(:id)
    end
  end

  def self.find_all(params)
    if params['id']
      where("id = ?", params[:id].to_i)
    elsif params['name']
      where('name = ?', params[:name])
    elsif params['description']
      where('LOWER(description) LIKE ?', "%#{params[:description].downcase}%")
    elsif params['unit_price']
      where('unit_price = ?', (params[:unit_price].to_f * 100).round(0))
    elsif params['merchant_id']
      where('(merchant_id::text) LIKE ?', "%#{params[:merchant_id]}%")
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end
end
